import argparse
import json
import sys
import time
import threading
import types
from dataclasses import dataclass
from pathlib import Path
from typing import Any


SCRIPT_DIR = Path(__file__).resolve().parent
PYATEM_SRC = SCRIPT_DIR / "_tmp_pyatem" / "pyatem-0.10.0"
if str(PYATEM_SRC) not in sys.path:
    sys.path.insert(0, str(PYATEM_SRC))


mediaconvert_stub = types.ModuleType("pyatem.mediaconvert")


def _unsupported_media(*_args: Any, **_kwargs: Any) -> bytes:
    raise NotImplementedError("pyatem.mediaconvert is unavailable; media conversion is not needed for this probe")


mediaconvert_stub.atem_to_rgb = _unsupported_media
mediaconvert_stub.rgb_to_atem = _unsupported_media
mediaconvert_stub.rle_encode = _unsupported_media
sys.modules.setdefault("pyatem.mediaconvert", mediaconvert_stub)

from pyatem.cameracontrol import ISO, Gain, ShutterSpeed, WhiteBalance, CameraControlData  # noqa: E402
from pyatem.protocol import AtemProtocol  # noqa: E402


@dataclass
class CameraControlPacket:
    destination: int
    category: int
    parameter: int
    datatype: int
    data: list[Any] | None


def unpack_fixed16(values: list[int]) -> list[float]:
    return [value / (2 ** 11) for value in values]


def parse_camera_control_packet(raw: bytes) -> CameraControlPacket | None:
    if len(raw) < 16:
        return None

    destination, category, parameter, datatype, *counts = raw[:12]
    num_elements = sum(counts)
    overrides = {
        (0, 0): 1,
        (0, 1): 0,
        (0, 2): 1,
        (0, 3): 1,
        (0, 4): 1,
        (0, 6): 1,
        (1, 2): 2,
    }
    num_elements = overrides.get((category, parameter), num_elements)

    data = None
    if len(raw) > 16 and num_elements > 0:
        payload = raw[16:]
        if datatype == 0:
            data = [bool(value) for value in payload[:num_elements]]
        elif datatype == 1:
            data = [int.from_bytes(payload[i:i + 1], "big", signed=True) for i in range(num_elements)]
        elif datatype == 2:
            data = [
                int.from_bytes(payload[i * 2:(i + 1) * 2], "big", signed=True)
                for i in range(num_elements)
            ]
        elif datatype == 3:
            data = [
                int.from_bytes(payload[i * 4:(i + 1) * 4], "big", signed=True)
                for i in range(num_elements)
            ]
        elif datatype == 4:
            data = [
                int.from_bytes(payload[i * 8:(i + 1) * 8], "big", signed=True)
                for i in range(num_elements)
            ]
        elif datatype == 5:
            data = [payload.rstrip(b"\x00").decode("utf-8", errors="replace")]
        elif datatype == 128:
            values = [
                int.from_bytes(payload[i * 2:(i + 1) * 2], "big", signed=True)
                for i in range(num_elements)
            ]
            data = unpack_fixed16(values)

    return CameraControlPacket(
        destination=destination,
        category=category,
        parameter=parameter,
        datatype=datatype,
        data=data,
    )


def typed_camera_control(packet: CameraControlPacket) -> CameraControlData | None:
    typed = CameraControlData.from_data(packet)
    return typed


def wait_for(predicate, timeout: float) -> bool:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if predicate():
            return True
        time.sleep(0.05)
    return False


def collect_state(seconds: float) -> None:
    deadline = time.time() + seconds
    while time.time() < deadline:
        time.sleep(0.05)


def main() -> int:
    parser = argparse.ArgumentParser(description="Probe ATEM camera control read/write access")
    parser.add_argument("--ip", required=True, help="ATEM IP address")
    parser.add_argument("--camera", type=int, required=True, help="ATEM camera/input destination")
    parser.add_argument("--collect-seconds", type=float, default=6.0, help="Initial read collection time")
    parser.add_argument("--write-test", action="store_true", help="Attempt one write and restore cycle")
    parser.add_argument(
        "--target",
        choices=["auto", "gain", "iso", "shutter", "whitebalance"],
        default="auto",
        help="Parameter to test when --write-test is enabled",
    )
    parser.add_argument(
        "--step",
        type=int,
        default=100,
        help="Step amount for write-test changes (ISO units, shutter units, or white balance kelvin)",
    )
    parser.add_argument(
        "--hold-seconds",
        type=float,
        default=2.0,
        help="Seconds to keep test value before restoring original",
    )
    parser.add_argument(
        "--write-timeout",
        type=float,
        default=2.5,
        help="Timeout for write/restore verification waits",
    )
    args = parser.parse_args()

    switcher = AtemProtocol(ip=args.ip)
    state: dict[str, Any] = {
        "connected": False,
        "camera_packets": {},
        "all_packets": {},
        "events": [],
    }

    def on_connected(*_args: Any) -> None:
        state["connected"] = True
        state["events"].append("connected")

    def on_disconnected(*_args: Any) -> None:
        state["events"].append("disconnected")

    def on_camera_packet(raw: bytes) -> None:
        packet = parse_camera_control_packet(raw)
        if packet is None:
            return
        typed = typed_camera_control(packet)
        entry: dict[str, Any] = {
            "destination": packet.destination,
            "category": packet.category,
            "parameter": packet.parameter,
            "datatype": packet.datatype,
            "raw_data": packet.data,
        }
        if typed is not None:
            entry["type"] = typed.__class__.__name__
            entry["decoded"] = dict(zip(typed.KEYS, typed.data or []))
        key = f"{packet.destination}:{packet.category}.{packet.parameter}"
        state["all_packets"][key] = entry
        if packet.destination == args.camera:
            state["camera_packets"][f"{packet.category}.{packet.parameter}"] = entry

    switcher.on("connected", on_connected)
    switcher.on("disconnected", on_disconnected)
    switcher.on("change:camera-control-data-packet:*", on_camera_packet)

    stop_event = threading.Event()

    def loop_worker() -> None:
        while not stop_event.is_set():
            try:
                switcher.loop()
            except Exception as exc:  # pragma: no cover
                state["events"].append(f"loop_error:{exc}")
                break

    worker = threading.Thread(target=loop_worker, name="atem-probe-loop", daemon=True)
    worker.start()

    switcher.connect()
    connected = wait_for(lambda: state["connected"], timeout=8.0)
    if not connected:
        stop_event.set()
        print(json.dumps({
            "connected": False,
            "error": f"Could not connect to ATEM at {args.ip}",
            "events": state["events"],
        }, indent=2))
        return 2

    collect_state(args.collect_seconds)

    result: dict[str, Any] = {
        "connected": True,
        "atem_ip": args.ip,
        "camera_input": args.camera,
        "product_name": getattr(switcher.mixerstate.get("product-name"), "name", None),
        "firmware_version": getattr(switcher.mixerstate.get("firmware-version"), "version", None),
        "camera_packets": state["camera_packets"],
        "write_test": {
            "attempted": False,
            "verified": False,
        },
    }

    if args.write_test:
        target_candidates = {
            "gain": [("1.1", Gain)],
            "iso": [("1.14", ISO)],
            "shutter": [("1.12", ShutterSpeed)],
            "whitebalance": [("1.2", WhiteBalance)],
            "auto": [
                ("1.1", Gain),
                ("1.14", ISO),
                ("1.12", ShutterSpeed),
                ("1.2", WhiteBalance),
            ],
        }
        write_candidates = target_candidates[args.target]
        for packet_key, command_cls in write_candidates:
            if packet_key not in state["camera_packets"]:
                continue

            packet_info = state["camera_packets"][packet_key]
            decoded = packet_info.get("decoded", {})
            restore_command = None
            test_command = None
            restore_delay = max(0.0, args.hold_seconds)
            step_amount = max(1, args.step)

            if command_cls is WhiteBalance and {"temperature", "tint"}.issubset(decoded):
                original_temp = int(decoded["temperature"])
                original_tint = int(decoded["tint"])
                test_temp = min(
                    10000,
                    max(2500, original_temp + step_amount if original_temp <= (10000 - step_amount) else original_temp - step_amount),
                )
                if test_temp == original_temp:
                    continue
                test_command = WhiteBalance(destination=args.camera, temperature=test_temp, tint=original_tint).to_command()
                restore_command = WhiteBalance(destination=args.camera, temperature=original_temp, tint=original_tint).to_command()
                expected_value = test_temp
                decoded_key = "temperature"
            elif command_cls is ISO and "iso" in decoded:
                original_iso = int(decoded["iso"])
                test_iso = max(100, original_iso + step_amount)
                test_command = ISO(destination=args.camera, iso=test_iso).to_command()
                restore_command = ISO(destination=args.camera, iso=original_iso).to_command()
                expected_value = test_iso
                decoded_key = "iso"
            elif command_cls is Gain and "ISO" in decoded:
                original_iso = int(decoded["ISO"])
                gain_step = max(1, int(round(step_amount / 100)))
                test_iso = original_iso + (gain_step * 100)
                test_command = Gain(destination=args.camera, ISO=int(test_iso / 100)).to_command()
                restore_command = Gain(destination=args.camera, ISO=int(original_iso / 100)).to_command()
                expected_value = test_iso
                decoded_key = "ISO"
            elif command_cls is ShutterSpeed and "speed" in decoded:
                original_speed = int(decoded["speed"])
                test_speed = min(
                    2000,
                    original_speed + step_amount if original_speed < (2000 - step_amount) else original_speed - step_amount,
                )
                if test_speed == original_speed:
                    continue
                test_command = ShutterSpeed(destination=args.camera, speed=test_speed).to_command()
                restore_command = ShutterSpeed(destination=args.camera, speed=original_speed).to_command()
                expected_value = test_speed
                decoded_key = "speed"
            else:
                continue

            result["write_test"]["attempted"] = True
            result["write_test"]["parameter"] = packet_info.get("type", packet_key)
            result["write_test"]["original"] = decoded

            switcher.send_commands([test_command])
            wait_for(
                lambda: state["camera_packets"].get(packet_key, {}).get("decoded", {}).get(decoded_key) == expected_value,
                timeout=args.write_timeout,
            )
            updated = state["camera_packets"].get(packet_key, {}).get("decoded", {})
            result["write_test"]["after_write"] = updated
            result["write_test"]["verified"] = updated.get(decoded_key) == expected_value

            time.sleep(restore_delay)
            switcher.send_commands([restore_command])
            wait_for(
                lambda: state["camera_packets"].get(packet_key, {}).get("decoded", {}).get(decoded_key) == decoded[decoded_key],
                timeout=args.write_timeout,
            )
            result["write_test"]["after_restore"] = state["camera_packets"].get(packet_key, {}).get("decoded", {})
            break

        if not result["write_test"]["attempted"]:
            result["write_test"]["reason"] = (
                f"No writable packet matched target '{args.target}' with currently decoded camera state"
            )

    stop_event.set()
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())