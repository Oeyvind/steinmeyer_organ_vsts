from __future__ import annotations

import argparse
import json
import sys
import threading
import time
import types
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    import cv2
except ModuleNotFoundError:  # pragma: no cover
    cv2 = None  # type: ignore[assignment]
try:
    import numpy as np
except ModuleNotFoundError:  # pragma: no cover
    np = None  # type: ignore[assignment]


SCRIPT_DIR = Path(__file__).resolve().parent
PYATEM_SRC = SCRIPT_DIR / "_tmp_pyatem" / "pyatem-0.10.0"
if str(PYATEM_SRC) not in sys.path:
    sys.path.insert(0, str(PYATEM_SRC))


mediaconvert_stub = types.ModuleType("pyatem.mediaconvert")


def _unsupported_media(*_args: Any, **_kwargs: Any) -> bytes:
    raise NotImplementedError("pyatem.mediaconvert is unavailable; media conversion is not needed for this calibrator")


mediaconvert_stub.atem_to_rgb = _unsupported_media
mediaconvert_stub.rgb_to_atem = _unsupported_media
mediaconvert_stub.rle_encode = _unsupported_media
sys.modules.setdefault("pyatem.mediaconvert", mediaconvert_stub)

try:
    from pyatem.cameracontrol import (
        Gain,
        ContrastAdjust,
        ColorAdjust,
        GainAdjust,
        ShutterSpeed,
        Exposure,
        WhiteBalance,
        TriggerAutowhitebalance,
        CameraControlData,
    )  # noqa: E402
    from pyatem.protocol import AtemProtocol  # noqa: E402
    PYATEM_IMPORT_ERROR: ModuleNotFoundError | None = None
except ModuleNotFoundError as exc:  # pragma: no cover
    PYATEM_IMPORT_ERROR = exc
    Gain = None  # type: ignore[assignment]
    ContrastAdjust = None  # type: ignore[assignment]
    ColorAdjust = None  # type: ignore[assignment]
    GainAdjust = None  # type: ignore[assignment]
    ShutterSpeed = None  # type: ignore[assignment]
    Exposure = None  # type: ignore[assignment]
    WhiteBalance = None  # type: ignore[assignment]
    TriggerAutowhitebalance = None  # type: ignore[assignment]
    CameraControlData = Any  # type: ignore[assignment]
    AtemProtocol = None  # type: ignore[assignment]


@dataclass
class CameraControlPacket:
    destination: int
    category: int
    parameter: int
    datatype: int
    data: list[Any] | None


def format_seconds(seconds: float) -> str:
    return f"{seconds:.2f}s"


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
    return CameraControlData.from_data(packet)


def wait_for(predicate, timeout: float) -> bool:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if predicate():
            return True
        time.sleep(0.05)
    return False


def choose_fast_gain_candidates(current_iso: int, candidates: list[int]) -> list[int]:
    if len(candidates) <= 4:
        return candidates
    reduced = sorted(set([
        max(min(candidates), current_iso - 100),
        current_iso,
        min(max(candidates), current_iso + 100),
        max(candidates),
    ]))
    filtered = [value for value in reduced if value in candidates]
    if len(filtered) < 3:
        return candidates[:4]
    return filtered


def parse_int_list(raw_values: str) -> list[int]:
    values = []
    for token in raw_values.split(","):
        token = token.strip()
        if not token:
            continue
        values.append(int(token))
    unique_sorted = sorted(set(values))
    return unique_sorted


def build_mask(height: int, width: int, corners: tuple[tuple[float, float], ...]) -> tuple[np.ndarray, int, int]:
    mask = np.zeros((height, width), dtype=np.uint8)
    pts = np.array(
        [[int(width * corner[0]), int(height * corner[1])] for corner in corners],
        dtype=np.int32,
    )
    cv2.fillPoly(mask, [pts], 255)
    mask_left = int(np.min(pts[:, 0]))
    mask_right = int(np.max(pts[:, 0]))
    return mask, mask_left, mask_right


def open_capture_with_retry(
    video_device: int,
    attempts: int = 10,
    retry_delay: float = 0.15,
    target_width: int | None = None,
    target_height: int | None = None,
) -> tuple[Any, Any]:
    """Open a camera and return first valid frame, retrying transient startup failures.

    On Windows, MSMF can fail to grab initial frames intermittently. Prefer DSHOW when
    available, then fall back to default backend.
    """
    backends: list[int | None] = []
    if hasattr(cv2, "CAP_DSHOW"):
        backends.append(cv2.CAP_DSHOW)
    backends.append(None)

    for backend in backends:
        cap = cv2.VideoCapture(video_device) if backend is None else cv2.VideoCapture(video_device, backend)
        if not cap.isOpened():
            cap.release()
            continue

        if target_width is not None and hasattr(cv2, "CAP_PROP_FRAME_WIDTH"):
            cap.set(cv2.CAP_PROP_FRAME_WIDTH, int(target_width))
        if target_height is not None and hasattr(cv2, "CAP_PROP_FRAME_HEIGHT"):
            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, int(target_height))

        frame = None
        # Warm-up reads + retries, because some devices start streaming after a delay.
        for _ in range(max(1, attempts)):
            ret, frame = cap.read()
            if ret and frame is not None:
                return cap, frame
            time.sleep(max(0.01, retry_delay))

        cap.release()

    return None, None


def sample_tracking_quality(
    cap: cv2.VideoCapture,
    mask: np.ndarray,
    mask_left: int,
    mask_right: int,
    blur_size: int,
    binary_thresh: int,
    sample_seconds: float,
    score_mode: str,
    target_width: int | None = None,
    target_height: int | None = None,
) -> dict[str, float]:
    frame_count = 0
    score_sum = 0.0
    coverage_sum = 0.0
    activation_sum = 0.0
    contrast_sum = 0.0
    clipping_sum = 0.0
    range_sum = 0.0
    sharpness_sum = 0.0
    brightness_sum = 0.0
    prev_gray = None

    deadline = time.time() + sample_seconds

    while time.time() < deadline:
        ret, frame = cap.read()
        if not ret:
            continue
        mask_for_frame = mask
        frame_mask_left = mask_left
        frame_mask_right = mask_right
        if target_width is not None and target_height is not None:
            current_height, current_width = frame.shape[:2]
            if current_width != target_width or current_height != target_height:
                frame = cv2.resize(frame, (int(target_width), int(target_height)), interpolation=cv2.INTER_AREA)
                mask_for_frame = cv2.resize(mask, (int(target_width), int(target_height)), interpolation=cv2.INTER_NEAREST)
                frame_mask_left = int(np.min(np.where(np.any(mask_for_frame > 0, axis=0))[0])) if np.any(mask_for_frame > 0) else 0
                frame_mask_right = int(np.max(np.where(np.any(mask_for_frame > 0, axis=0))[0]) + 1) if np.any(mask_for_frame > 0) else 1
        mask_pixel_count = max(1, int(np.count_nonzero(mask_for_frame)))
        roi_width = max(1, frame_mask_right - frame_mask_left)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        if prev_gray is None:
            prev_gray = gray
            continue

        frame_diff = cv2.absdiff(gray, prev_gray)
        prev_gray = gray

        frame_diff_masked = cv2.bitwise_and(frame_diff, frame_diff, mask=mask_for_frame)
        frame_diff_blurred = cv2.blur(frame_diff_masked, (blur_size, blur_size))
        _, binary_img = cv2.threshold(frame_diff_blurred, binary_thresh, 255, cv2.THRESH_BINARY)

        activation = float(np.sum(binary_img) / (mask_pixel_count * 255))

        roi_binary = binary_img[:, frame_mask_left:frame_mask_right]
        if roi_binary.size > 0:
            column_activity = np.any(roi_binary > 0, axis=0)
            coverage = float(np.mean(column_activity))
        else:
            coverage = 0.0

        roi_gray = gray[mask_for_frame > 0]
        if roi_gray.size > 0:
            contrast = float(np.std(roi_gray) / 64.0)
            dark_clip = float(np.mean(roi_gray < 8))
            bright_clip = float(np.mean(roi_gray > 247))
            clipping = dark_clip + bright_clip
            p5 = float(np.percentile(roi_gray, 5))
            p95 = float(np.percentile(roi_gray, 95))
            dynamic_range = (p95 - p5) / 255.0
            brightness = float(np.mean(roi_gray) / 255.0)
            roi_gray_2d = gray.copy()
            roi_gray_2d[mask_for_frame == 0] = 0
            laplacian_var = float(cv2.Laplacian(roi_gray_2d, cv2.CV_32F).var())
            sharpness = float(np.clip(laplacian_var / 2000.0, 0.0, 2.5))
        else:
            contrast = 0.0
            clipping = 1.0
            dynamic_range = 0.0
            brightness = 1.0
            sharpness = 0.0

        over_brightness = max(0.0, brightness - 0.52)
        under_brightness = max(0.0, 0.32 - brightness)

        if score_mode == "static":
            score = (
                (1.8 * dynamic_range)
                + (1.3 * sharpness)
                + (0.3 * contrast)
                - (2.4 * clipping)
                - (2.2 * over_brightness)
                - (0.8 * under_brightness)
            )
        elif score_mode == "motion":
            score = (
                (1.2 * coverage)
                + (0.7 * activation)
                + (1.2 * dynamic_range)
                + (0.9 * sharpness)
                + (0.2 * contrast)
                - (1.9 * clipping)
                - (2.0 * over_brightness)
                - (0.6 * under_brightness)
            )
        else:  # hybrid
            score = (
                (0.7 * coverage)
                + (0.5 * activation)
                + (1.5 * dynamic_range)
                + (1.1 * sharpness)
                + (0.4 * contrast)
                - (2.0 * clipping)
                - (2.1 * over_brightness)
                - (0.7 * under_brightness)
            )

        frame_count += 1
        score_sum += score
        coverage_sum += coverage
        activation_sum += activation
        contrast_sum += contrast
        clipping_sum += clipping
        range_sum += dynamic_range
        sharpness_sum += sharpness
        brightness_sum += brightness

    if frame_count == 0:
        return {
            "score": -999.0,
            "coverage": 0.0,
            "activation": 0.0,
            "contrast": 0.0,
            "clipping": 1.0,
            "dynamic_range": 0.0,
            "sharpness": 0.0,
            "brightness": 1.0,
            "frames": 0,
        }

    return {
        "score": score_sum / frame_count,
        "coverage": coverage_sum / frame_count,
        "activation": activation_sum / frame_count,
        "contrast": contrast_sum / frame_count,
        "clipping": clipping_sum / frame_count,
        "dynamic_range": range_sum / frame_count,
        "sharpness": sharpness_sum / frame_count,
        "brightness": brightness_sum / frame_count,
        "frames": frame_count,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Auto-calibrate ATEM camera settings for rope tracking")
    parser.add_argument("--ip", required=True, help="ATEM IP address")
    parser.add_argument("--camera", type=int, required=True, help="ATEM camera/input destination")
    parser.add_argument("--video-device", type=int, default=1, help="OpenCV video capture device index")
    parser.add_argument("--collect-seconds", type=float, default=3.0, help="Initial ATEM state collection time")
    parser.add_argument("--gain-values", default="100,200,300,400,500,600", help="Comma-separated ISO values to test")
    parser.add_argument("--settle-seconds", type=float, default=0.8, help="Wait after each gain change before sampling")
    parser.add_argument("--sample-seconds", type=float, default=1.6, help="Sampling duration per gain setting")
    parser.add_argument("--write-timeout", type=float, default=2.5, help="Timeout for ATEM state verification")
    parser.add_argument("--blur-size", type=int, default=5, help="Blur kernel size used in rope visibility scoring")
    parser.add_argument("--binary-thresh", type=int, default=15, help="Binary threshold used in rope visibility scoring")
    parser.add_argument("--mode", choices=["static", "motion", "hybrid"], default="motion", help="Scoring mode")
    parser.add_argument("--strategy", choices=["extended", "simple"], default="extended", help="Calibration strategy")
    parser.add_argument("--fallback-simple", action=argparse.BooleanOptionalAction, default=True, help="Fallback to simple calibration if extended fails")
    parser.add_argument("--apply-best", action=argparse.BooleanOptionalAction, default=True, help="Apply best setting at end")
    args = parser.parse_args()

    output, status = run_auto_calibration(
        atem_ip=args.ip,
        camera=args.camera,
        video_device=args.video_device,
        collect_seconds=args.collect_seconds,
        gain_values=parse_int_list(args.gain_values),
        settle_seconds=args.settle_seconds,
        sample_seconds=args.sample_seconds,
        write_timeout=args.write_timeout,
        blur_size=args.blur_size,
        binary_thresh=args.binary_thresh,
        mode=args.mode,
        strategy=args.strategy,
        fallback_simple=args.fallback_simple,
        apply_best=args.apply_best,
    )
    print(json.dumps(output, indent=2, sort_keys=True))
    return status


def run_simple_calibration(
    atem_ip: str,
    camera: int,
    video_device: int = 1,
    target_width: int = 960,
    target_height: int = 540,
    collect_seconds: float = 3.0,
    gain_values: list[int] | None = None,
    settle_seconds: float = 0.8,
    sample_seconds: float = 1.6,
    write_timeout: float = 2.5,
    blur_size: int = 5,
    binary_thresh: int = 15,
    mode: str = "motion",
    strategy: str = "simple",
    fallback_simple: bool = True,
    apply_best: bool = True,
    verbose: bool = True,
    enforce_shutter_1_75: bool = True,
    run_auto_whitebalance: bool = True,
) -> tuple[dict[str, Any], int]:
    t0 = time.time()

    if cv2 is None:
        return {
            "connected": False,
            "error": "Missing dependency: cv2 (opencv-python). Install with: python310 -m pip install opencv-python",
        }, 2

    if np is None:
        return {
            "connected": False,
            "error": "Missing dependency: numpy. Install with: python310 -m pip install numpy",
        }, 2

    if PYATEM_IMPORT_ERROR is not None:
        return {
            "connected": False,
            "error": f"Missing dependency: {PYATEM_IMPORT_ERROR.name}. Install with: python310 -m pip install pyusb",
        }, 2

    blur_size = max(1, int(blur_size))
    if blur_size % 2 == 0:
        blur_size += 1

    gain_values = gain_values or [100, 200, 300, 400, 500, 600]
    if not gain_values:
        return {"connected": False, "error": "No gain values provided"}, 2

    gain_values = [max(100, int(round(value / 100.0) * 100)) for value in gain_values]
    gain_values = sorted(set(gain_values))

    cap, frame = open_capture_with_retry(
        video_device=video_device,
        attempts=12,
        retry_delay=0.15,
        target_width=target_width,
        target_height=target_height,
    )
    if cap is None or frame is None:
        return {
            "connected": False,
            "error": f"Could not open video device index {video_device} (no valid frames received)",
        }, 2

    frame_height, frame_width = frame.shape[:2]
    corners = (
        (0.05, 0.05),
        (0.95, 0.05),
        (0.95, 0.95),
        (0.05, 0.95),
    )
    mask, mask_left, mask_right = build_mask(frame_height, frame_width, corners)

    switcher = AtemProtocol(ip=atem_ip)
    state: dict[str, Any] = {
        "connected": False,
        "camera_packets": {},
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
        if packet.destination == camera:
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

    worker = threading.Thread(target=loop_worker, name="atem-calibrate-loop", daemon=True)
    worker.start()

    switcher.connect()
    if verbose:
        print("[calib] waiting for ATEM switcher reply on network...")
    connected = wait_for(lambda: state["connected"], timeout=8.0)
    if not connected:
        stop_event.set()
        cap.release()
        return {
            "connected": False,
            "error": f"Could not connect to ATEM at {atem_ip}",
            "events": state["events"],
        }, 2

    if verbose:
        print(f"[calib] collecting initial ATEM camera packets ({format_seconds(max(0.0, collect_seconds))})")
    time.sleep(max(0.0, collect_seconds))

    shutter_applied = None
    wb_action = "none"
    if enforce_shutter_1_75 and ("1.12" in state["camera_packets"]):
        if verbose:
            print("[calib] setting shutter speed to 1/75")
        switcher.send_commands([ShutterSpeed(destination=camera, speed=75).to_command()])
        time.sleep(0.25)
        shutter_applied = 75
    elif enforce_shutter_1_75 and ("1.5" in state["camera_packets"]):
        if verbose:
            print("[calib] shutter packet unavailable; setting exposure time to 13333us (~1/75)")
        switcher.send_commands([Exposure(destination=camera, time=13333).to_command()])
        time.sleep(0.25)
        shutter_applied = 75
    elif enforce_shutter_1_75 and verbose:
        print("[calib] shutter control packet not available; skipping 1/75 set")

    if run_auto_whitebalance and ("1.2" in state["camera_packets"]):
        if verbose:
            print("[calib] running ATEM auto white balance")
        switcher.send_commands([TriggerAutowhitebalance(destination=camera).to_command()])
        time.sleep(0.8)
        wb_action = "triggered"
    elif run_auto_whitebalance and verbose:
        print("[calib] white balance control packet not available; skipping auto WB")

    gain_packet_key = "1.1"
    gain_packet = state["camera_packets"].get(gain_packet_key, {})
    current_gain_decoded = gain_packet.get("decoded", {})
    current_iso = int(current_gain_decoded.get("ISO", 0)) if "ISO" in current_gain_decoded else 0
    if current_iso <= 0:
        stop_event.set()
        cap.release()
        return {
            "connected": True,
            "error": "Current gain/ISO state unavailable (expected camera packet 1.1 with decoded ISO)",
            "camera_packets": state["camera_packets"],
        }, 2

    gain_values = sorted(set(gain_values + [current_iso]))
    gain_values = choose_fast_gain_candidates(current_iso, gain_values)
    if verbose:
        est_seconds = len(gain_values) * (max(0.0, settle_seconds) + max(0.3, sample_seconds))
        print(f"[calib] scanning {len(gain_values)} ISO candidates (estimated {format_seconds(est_seconds)})")

    results: list[dict[str, Any]] = []

    for idx, iso_value in enumerate(gain_values, start=1):
        switcher.send_commands([Gain(destination=camera, ISO=int(iso_value / 100)).to_command()])
        wait_for(
            lambda: state["camera_packets"].get(gain_packet_key, {}).get("decoded", {}).get("ISO") == iso_value,
            timeout=max(0.1, write_timeout),
        )
        time.sleep(max(0.0, settle_seconds))

        quality = sample_tracking_quality(
            cap=cap,
            mask=mask,
            mask_left=mask_left,
            mask_right=mask_right,
            blur_size=blur_size,
            binary_thresh=max(1, int(binary_thresh)),
            sample_seconds=max(0.3, sample_seconds),
            score_mode=mode,
            target_width=target_width,
            target_height=target_height,
        )
        quality["iso"] = iso_value
        results.append(quality)
        if verbose:
            print(
                f"[calib] ISO {iso_value} ({idx}/{len(gain_values)}): "
                f"score={quality['score']:.3f}, range={quality['dynamic_range']:.3f}, sharpness={quality['sharpness']:.3f}, clipping={quality['clipping']:.3f}"
            )

    bright_safe_candidates = [
        item for item in results
        if item.get("brightness", 1.0) <= 0.56 and item.get("clipping", 1.0) <= 0.10
    ]
    if len(bright_safe_candidates) > 0:
        best_result = max(bright_safe_candidates, key=lambda item: item["score"])
        if verbose:
            print("[calib] applying anti-overexposure guard when selecting best ISO")
    else:
        best_result = max(results, key=lambda item: item["score"])
    best_iso = int(best_result["iso"])

    if apply_best:
        final_iso = best_iso
    else:
        final_iso = current_iso

    switcher.send_commands([Gain(destination=camera, ISO=int(final_iso / 100)).to_command()])
    wait_for(
        lambda: state["camera_packets"].get(gain_packet_key, {}).get("decoded", {}).get("ISO") == final_iso,
        timeout=max(0.1, write_timeout),
    )

    final_state = state["camera_packets"].get(gain_packet_key, {}).get("decoded", {})

    stop_event.set()
    cap.release()

    output = {
        "connected": True,
        "strategy": "simple",
        "atem_ip": atem_ip,
        "camera_input": camera,
        "video_device": video_device,
        "mode": mode,
        "current_iso": current_iso,
        "candidate_iso_values": gain_values,
        "best_iso": best_iso,
        "applied_iso": final_iso,
        "apply_best": apply_best,
        "shutter_applied": shutter_applied,
        "white_balance_action": wb_action,
        "results": sorted(results, key=lambda item: item["score"], reverse=True),
        "final_gain_state": final_state,
        "note": "Use mode=static for idle startup baseline, mode=motion while moving rope.",
        "timing_seconds": {
            "total": float(time.time() - t0),
            "per_candidate_estimate": float(max(0.0, settle_seconds) + max(0.3, sample_seconds)),
        },
    }
    if verbose:
        print(f"[calib] simple calibration done in {format_seconds(output['timing_seconds']['total'])}, selected ISO {final_iso}")
    return output, 0


def run_extended_calibration(
    atem_ip: str,
    camera: int,
    video_device: int = 1,
    target_width: int = 960,
    target_height: int = 540,
    collect_seconds: float = 3.0,
    gain_values: list[int] | None = None,
    settle_seconds: float = 0.8,
    sample_seconds: float = 1.6,
    write_timeout: float = 2.5,
    blur_size: int = 5,
    binary_thresh: int = 15,
    mode: str = "motion",
    strategy: str = "extended",
    fallback_simple: bool = True,
    apply_best: bool = True,
    verbose: bool = True,
    enforce_shutter_1_75: bool = True,
    run_auto_whitebalance: bool = True,
) -> tuple[dict[str, Any], int]:
    t0 = time.time()
    simple_result, simple_status = run_simple_calibration(
        atem_ip=atem_ip,
        camera=camera,
        video_device=video_device,
        target_width=target_width,
        target_height=target_height,
        collect_seconds=collect_seconds,
        gain_values=gain_values,
        settle_seconds=settle_seconds,
        sample_seconds=sample_seconds,
        write_timeout=write_timeout,
        blur_size=blur_size,
        binary_thresh=binary_thresh,
        mode=mode,
        apply_best=apply_best,
        verbose=verbose,
        enforce_shutter_1_75=enforce_shutter_1_75,
        run_auto_whitebalance=run_auto_whitebalance,
    )
    if simple_status != 0:
        return {
            "connected": simple_result.get("connected", False),
            "strategy": "extended",
            "error": "Extended calibration could not start because simple calibration failed",
            "simple_error": simple_result.get("error"),
        }, simple_status

    if PYATEM_IMPORT_ERROR is not None:
        return {
            "connected": False,
            "strategy": "extended",
            "error": f"Missing dependency: {PYATEM_IMPORT_ERROR.name}",
        }, 2

    cap, frame = open_capture_with_retry(
        video_device=video_device,
        attempts=12,
        retry_delay=0.15,
        target_width=target_width,
        target_height=target_height,
    )
    if cap is None or frame is None:
        return {
            "connected": False,
            "strategy": "extended",
            "error": f"Could not open video device index {video_device} for color refinement (no valid frames received)",
        }, 2

    frame_height, frame_width = frame.shape[:2]
    corners = (
        (0.05, 0.05),
        (0.95, 0.05),
        (0.95, 0.95),
        (0.05, 0.95),
    )
    mask, mask_left, mask_right = build_mask(frame_height, frame_width, corners)

    switcher = AtemProtocol(ip=atem_ip)
    state: dict[str, Any] = {
        "connected": False,
        "camera_packets": {},
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
        if packet.destination == camera:
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

    worker = threading.Thread(target=loop_worker, name="atem-extended-loop", daemon=True)
    worker.start()

    switcher.connect()
    if verbose:
        print("[calib] extended phase: waiting for ATEM switcher reply on network...")
    connected = wait_for(lambda: state["connected"], timeout=8.0)
    if not connected:
        stop_event.set()
        cap.release()
        return {
            "connected": False,
            "strategy": "extended",
            "error": f"Could not connect to ATEM at {atem_ip} for color refinement",
            "events": state["events"],
        }, 2

    if verbose:
        print(f"[calib] extended phase: collecting camera color packets ({format_seconds(max(0.0, collect_seconds))})")
    time.sleep(max(0.0, collect_seconds))

    contrast_packet = state["camera_packets"].get("8.4", {}).get("decoded", {})
    color_packet = state["camera_packets"].get("8.6", {}).get("decoded", {})
    gain_adjust_packet = state["camera_packets"].get("8.2", {}).get("decoded", {})
    if not ({"pivot", "adjust"}.issubset(contrast_packet) and {"hue", "saturation"}.issubset(color_packet) and {"red", "green", "blue", "luma"}.issubset(gain_adjust_packet)):
        stop_event.set()
        cap.release()
        return {
            "connected": True,
            "strategy": "extended",
            "error": "Color/brightness refinement packets unavailable (need 8.2 GainAdjust, 8.4 ContrastAdjust, 8.6 ColorAdjust)",
        }, 2

    base_pivot = float(contrast_packet["pivot"])
    base_contrast = float(contrast_packet["adjust"])
    base_hue = float(color_packet["hue"])
    base_saturation = float(color_packet["saturation"])
    base_gain_red = float(gain_adjust_packet["red"])
    base_gain_green = float(gain_adjust_packet["green"])
    base_gain_blue = float(gain_adjust_packet["blue"])
    base_gain_luma = float(gain_adjust_packet["luma"])

    contrast_candidates = [
        float(np.clip(base_contrast + delta, 0.5, 1.8))
        for delta in (-0.10, 0.0)
    ]
    saturation_candidates = [
        float(np.clip(base_saturation + delta, 0.6, 1.6))
        for delta in (-0.08, 0.08)
    ]
    gain_luma_candidates = [
        float(np.clip(base_gain_luma + delta, 0.75, 1.05))
        for delta in (-0.12, 0.0)
    ]
    contrast_candidates = sorted(set(contrast_candidates))
    saturation_candidates = sorted(set(saturation_candidates))
    gain_luma_candidates = sorted(set(gain_luma_candidates))

    color_results: list[dict[str, Any]] = []
    total_candidates = len(contrast_candidates) * len(saturation_candidates) * len(gain_luma_candidates)
    if verbose:
        est_seconds = total_candidates * (max(0.0, settle_seconds) + max(0.3, sample_seconds))
        print(f"[calib] extended phase: scanning {total_candidates} luma/contrast/saturation candidates (estimated {format_seconds(est_seconds)})")

    cand_idx = 0
    for gain_luma_value in gain_luma_candidates:
        for contrast_value in contrast_candidates:
            for saturation_value in saturation_candidates:
                cand_idx += 1
                switcher.send_commands([
                    GainAdjust(
                        destination=camera,
                        red=base_gain_red,
                        green=base_gain_green,
                        blue=base_gain_blue,
                        luma=gain_luma_value,
                    ).to_command(),
                    ContrastAdjust(destination=camera, pivot=base_pivot, adjust=contrast_value).to_command(),
                    ColorAdjust(destination=camera, hue=base_hue, saturation=saturation_value).to_command(),
                ])
                time.sleep(max(0.0, settle_seconds))

                quality = sample_tracking_quality(
                    cap=cap,
                    mask=mask,
                    mask_left=mask_left,
                    mask_right=mask_right,
                    blur_size=max(1, int(blur_size)),
                    binary_thresh=max(1, int(binary_thresh)),
                    sample_seconds=max(0.3, sample_seconds),
                    score_mode=mode,
                    target_width=target_width,
                    target_height=target_height,
                )
                quality["contrast_adjust"] = contrast_value
                quality["saturation"] = saturation_value
                quality["gain_luma"] = gain_luma_value
                color_results.append(quality)
                if verbose:
                    print(
                        f"[calib] color {cand_idx}/{total_candidates}: luma={gain_luma_value:.3f}, contrast={contrast_value:.3f}, sat={saturation_value:.3f}, "
                        f"score={quality['score']:.3f}, range={quality['dynamic_range']:.3f}, sharpness={quality['sharpness']:.3f}"
                    )

    if len(color_results) == 0:
        stop_event.set()
        cap.release()
        return {
            "connected": True,
            "strategy": "extended",
            "error": "No color refinement candidates evaluated",
        }, 2

    best_color = max(color_results, key=lambda item: item["score"])
    best_contrast = float(best_color["contrast_adjust"])
    best_saturation = float(best_color["saturation"])
    best_gain_luma = float(best_color["gain_luma"])

    if apply_best:
        final_contrast = best_contrast
        final_saturation = best_saturation
        final_gain_luma = best_gain_luma
    else:
        final_contrast = base_contrast
        final_saturation = base_saturation
        final_gain_luma = base_gain_luma

    switcher.send_commands([
        GainAdjust(
            destination=camera,
            red=base_gain_red,
            green=base_gain_green,
            blue=base_gain_blue,
            luma=final_gain_luma,
        ).to_command(),
        ContrastAdjust(destination=camera, pivot=base_pivot, adjust=final_contrast).to_command(),
        ColorAdjust(destination=camera, hue=base_hue, saturation=final_saturation).to_command(),
    ])
    time.sleep(max(0.2, write_timeout * 0.5))

    final_contrast_packet = state["camera_packets"].get("8.4", {}).get("decoded", {})
    final_color_packet = state["camera_packets"].get("8.6", {}).get("decoded", {})
    final_gain_adjust_packet = state["camera_packets"].get("8.2", {}).get("decoded", {})

    stop_event.set()
    cap.release()

    output = dict(simple_result)
    output["strategy"] = "extended"
    output["extended"] = {
        "base": {
            "contrast_adjust": base_contrast,
            "saturation": base_saturation,
            "gain_luma": base_gain_luma,
            "pivot": base_pivot,
            "hue": base_hue,
        },
        "best": {
            "contrast_adjust": best_contrast,
            "saturation": best_saturation,
            "gain_luma": best_gain_luma,
        },
        "applied": {
            "contrast_adjust": final_contrast,
            "saturation": final_saturation,
            "gain_luma": final_gain_luma,
        },
        "results": sorted(color_results, key=lambda item: item["score"], reverse=True),
        "final_packets": {
            "8.2": final_gain_adjust_packet,
            "8.4": final_contrast_packet,
            "8.6": final_color_packet,
        },
        "timing_seconds": {
            "extended_phase_total": float(time.time() - t0),
            "candidate_count": total_candidates,
        },
    }
    if verbose:
        print(
            f"[calib] extended calibration done in {format_seconds(time.time()-t0)}, "
            f"contrast={final_contrast:.3f}, saturation={final_saturation:.3f}"
        )
    return output, 0


def run_auto_calibration(
    atem_ip: str,
    camera: int,
    video_device: int = 1,
    target_width: int = 960,
    target_height: int = 540,
    collect_seconds: float = 3.0,
    gain_values: list[int] | None = None,
    settle_seconds: float = 0.8,
    sample_seconds: float = 1.6,
    write_timeout: float = 2.5,
    blur_size: int = 5,
    binary_thresh: int = 15,
    mode: str = "motion",
    strategy: str = "extended",
    fallback_simple: bool = True,
    apply_best: bool = True,
    verbose: bool = True,
    enforce_shutter_1_75: bool = True,
    run_auto_whitebalance: bool = True,
) -> tuple[dict[str, Any], int]:
    if strategy == "simple":
        return run_simple_calibration(
            atem_ip=atem_ip,
            camera=camera,
            video_device=video_device,
            target_width=target_width,
            target_height=target_height,
            collect_seconds=collect_seconds,
            gain_values=gain_values,
            settle_seconds=settle_seconds,
            sample_seconds=sample_seconds,
            write_timeout=write_timeout,
            blur_size=blur_size,
            binary_thresh=binary_thresh,
            mode=mode,
            apply_best=apply_best,
            verbose=verbose,
            enforce_shutter_1_75=enforce_shutter_1_75,
            run_auto_whitebalance=run_auto_whitebalance,
        )

    extended_result, extended_status = run_extended_calibration(
        atem_ip=atem_ip,
        camera=camera,
        video_device=video_device,
        target_width=target_width,
        target_height=target_height,
        collect_seconds=collect_seconds,
        gain_values=gain_values,
        settle_seconds=settle_seconds,
        sample_seconds=sample_seconds,
        write_timeout=write_timeout,
        blur_size=blur_size,
        binary_thresh=binary_thresh,
        mode=mode,
        apply_best=apply_best,
        verbose=verbose,
        enforce_shutter_1_75=enforce_shutter_1_75,
        run_auto_whitebalance=run_auto_whitebalance,
    )
    if extended_status == 0:
        return extended_result, 0

    if not fallback_simple:
        return extended_result, extended_status

    if verbose:
        print(f"[calib] extended failed -> fallback to simple ({extended_result.get('error', 'unknown reason')})")

    simple_result, simple_status = run_simple_calibration(
        atem_ip=atem_ip,
        camera=camera,
        video_device=video_device,
        collect_seconds=collect_seconds,
        gain_values=gain_values,
        settle_seconds=settle_seconds,
        sample_seconds=sample_seconds,
        write_timeout=write_timeout,
        blur_size=blur_size,
        binary_thresh=binary_thresh,
        mode=mode,
        apply_best=apply_best,
        verbose=verbose,
        enforce_shutter_1_75=enforce_shutter_1_75,
        run_auto_whitebalance=run_auto_whitebalance,
    )
    simple_result["fallback_from"] = "extended"
    simple_result["fallback_reason"] = extended_result.get("error", "extended calibration failed")
    return simple_result, simple_status


if __name__ == "__main__":
    raise SystemExit(main())