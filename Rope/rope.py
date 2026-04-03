import cv2
import numpy as np 
from scipy.ndimage import median_filter
from scipy.signal import butter, sosfiltfilt, lfilter, find_peaks as scipy_find_peaks
import osc_io
import time
import json
import argparse
import multiprocessing as mp
from pathlib import Path
from collections import deque
from queue import Empty, Full

try:
    from atem_auto_calibrate import run_auto_calibration
except Exception:
    run_auto_calibration = None

timethen = time.time()
SCRIPT_DIR = Path(__file__).resolve().parent
test_video_path = SCRIPT_DIR / 'test_video.avi'


# config parms
binary_thresh = 20
blur_size = 10
fps = 20
flip = False
video_device = 1
mask_up_left  = (0.05, 0.05)
mask_up_right = (0.95, 0.05)
mask_lo_right = (0.95, 0.95)
mask_lo_left  = (0.05, 0.95)
displaysize = 1000
record_max_seconds = 60.0
bg_alpha = 0.05  # background model time constant: lower = slower adaptation
dark_floor = 30   # pixels with bg average below this are treated as persistent dark regions and excluded
max_spatial_jump_px = 18
max_temporal_deviation_px = 65
kinematic_min_obs_pixels = 2
endpoint_memory_min_obs_pixels = 1
kinematic_snap_to_obs_px = 22
kinematic_edge_anchor_px = 24
peak_min_amplitude_frac = 0.010
peak_min_prominence_frac = 0.020
peak_min_distance_frac = 0.045
sine_display_cycles = np.array([
    0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75,   # orange: 0.25-step below 3
    3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5,      # green: 0.5-step 3???10
    9.0, 9.5, 10.0
], dtype=np.float32)
sine_highmode_start_cycles = 10.0
sine_display_height = 190
# ?????? Hex grid isomorphic keyboard layouts ???????????????????????????????????????????????????????????????????????????????????????????????????????????????
# Each entry: (name, semitone_step_per_q, semitone_step_per_r)
# Grid uses flat-top hexagons in axial (q, r) coordinates.
hex_grid_fields_x = 6   # desired number of hex fields across ROI (horizontal)
hex_grid_fields_y = 6   # desired number of hex fields across ROI (vertical)
HEX_LAYOUTS = [
    ("Harmonic",     7, 4),   # Harmonic Table (C-Thru): P5 along q, M3 along r
    ("Wicki-Hayden", 2, 7),   # Wicki-Hayden: M2 along q, P5 along r
    ("Tonnetz",      7, 3),   # Euler Tonnetz: P5 along q, m3 along r
    ("Harmonetta",   4, 3),   # Harmonetta: M3 along q, m3 along r
    ("Janko",        2, 1),   # Janko: whole-tone q, semitone r
    ("Chromatic",    1, 4),   # Chromatic: semitone q, P4 r
]
sine_display_db_floor = -40.0  # dB floor for display; -40dB = amplitude 1/100 of full swing
sine_display_db_ceiling = 32.0  # positive headroom so strong modes do not saturate too early
sine_display_shape_gamma = 1.8  # emphasize high-end differences in normalized display values
sine_display_peak_emphasis_exp = 2.05
sine_display_peak_renorm_ref = 0.5
sine_amplitude_scale = 3.0
sine_fluct_weight_base = 0.58
sine_fluct_weight_gain = 0.42
sine_fluct_emphasis_exp = 1.35
sine_highcut_start_cycles = 4.0
sine_highcut_alpha = 2.2         # stronger damping above physical rope range
sine_noise_floor_start_cycles = 4.5
sine_noise_floor_subtract = 0.70
wave_motion_display_max = 5.0
wave_motion_slider_max = 2.5
wave_motion_max_lag_px = 48
wave_motion_smooth_alpha = 0.25
wave_motion_activity_gate = 0.05
wave_activity_attack_alpha = 0.38
wave_activity_release_alpha = 0.12
wave_activity_curve_gamma = 1.5
shape_state_labels = ['straight', 'one-bump', 'arc', 'periodic', 'endpoint-lost', 'mixed']
shape_state_smooth_alpha = 0.22
shape_state_switch_margin = 0.08
shape_state_min_score = 0.38
numpeaks_median_window_frames = max(1, int(round(fps / 3.0)))
if numpeaks_median_window_frames % 2 == 0:
    numpeaks_median_window_frames += 1
numpeaks_lowpass_cutoff_hz = 0.5
numpeaks_lp_dt = 1.0 / max(float(fps), 1.0)
numpeaks_lp_rc = 1.0 / (2.0 * np.pi * numpeaks_lowpass_cutoff_hz)
numpeaks_lowpass_alpha = float(np.clip(numpeaks_lp_dt / (numpeaks_lp_rc + numpeaks_lp_dt), 0.0, 1.0))
amp_comp_n_ref = 2.0       # reference numpeaks for frequency-compensated amplitude
amp_comp_gamma = 0.5       # exponent: >1 boosts high-freq, <1 compresses
curvature_profile_samples = 64
curvature_sensitivity = 0.588
curvature_slope_mix = 0.75  # blend in first-derivative steepness to catch sharp turns
curvature_gamma = 1.5
shape_centroid_weight_floor_frac = 0.035  # ignore tiny centroid contributions close to centerline
shape_centroid_weight_gamma = 2.15        # emphasize large off-center excursions
shape_centroid_offcenter_power = 1.0      # >1 de-emphasizes small off-center centroid moves
shape_centroid_center_deadzone = 0.012    # normalized x deadzone around center (0.5)
shape_centroid_smooth_alpha = 0.22        # temporal smoothing for centroid stability

# optional ATEM calibration
atem_enable_calibration = True
atem_ip = '172.31.57.153'
atem_camera_input = 1
atem_gain_values = [100, 200, 300, 400, 500, 600]
atem_collect_seconds = 2.0
atem_settle_seconds = 0.8
atem_sample_seconds_static = 1.2
atem_sample_seconds_motion = 1.8

_HEX_SQRT3 = np.sqrt(3.0)


def _hex_center_px(q, r, ox, oy, size_x, size_y):
    return ox + size_x * 1.5 * q, oy + size_y * (_HEX_SQRT3 * 0.5 * q + _HEX_SQRT3 * r)


def _hex_verts(cx, cy, size_x, size_y):
    return np.array([[int(cx + size_x * np.cos(np.radians(60.0 * i))),
                      int(cy + size_y * np.sin(np.radians(60.0 * i)))] for i in range(6)], dtype=np.int32)


def display_worker_process(frame_queue, key_queue, stop_event, window_name, out_size):
    cv2.namedWindow(window_name, cv2.WINDOW_NORMAL)
    while not stop_event.is_set():
        try:
            payload = frame_queue.get(timeout=0.03)
        except Empty:
            key = cv2.waitKey(1) & 0xFF
            if key != 255:
                try:
                    key_queue.put_nowait(key)
                except Full:
                    pass
            continue

        if payload is None:
            break

        output = compose_display_frame(payload, out_size)
        total_skipped = payload['total_skipped']
        current_skipped = payload['current_skipped']
        underflow_text = payload['underflow_text']
        underflow_color = payload['underflow_color']

        skip_text = f'skipped total:{int(total_skipped)}  current:{int(current_skipped)}'
        font = cv2.FONT_HERSHEY_SIMPLEX
        scale = 0.54
        thickness = 1
        pad = 10
        uf_text = underflow_text if underflow_text else 'underflow n/a'
        status_text = f'{skip_text}  |  {uf_text}'
        (status_w, line_h), _ = cv2.getTextSize(status_text, font, scale, thickness)
        panel_w = status_w + (pad * 2)
        panel_h = line_h + (pad * 2)
        panel_x = max(6, output.shape[1] - panel_w - 10)
        panel_y = max(0, output.shape[0] - panel_h)
        cv2.rectangle(output, (panel_x, panel_y), (panel_x + panel_w, panel_y + panel_h), (0, 0, 0), -1)
        y = panel_y + pad + line_h
        cv2.putText(output, status_text, (panel_x + pad, y), font, scale, underflow_color, thickness, cv2.LINE_AA)

        cv2.imshow(window_name, output)
        key = cv2.waitKey(1) & 0xFF
        if key != 255:
            try:
                key_queue.put_nowait(key)
            except Full:
                pass

    cv2.destroyAllWindows()


def draw_transparent_rect_display(image, x, y, width, height, alpha=0.45):
    x = max(0, int(x))
    y = max(0, int(y))
    width = max(1, int(width))
    height = max(1, int(height))
    x2 = min(image.shape[1], x + width)
    y2 = min(image.shape[0], y + height)
    if x2 <= x or y2 <= y:
        return
    overlay = image.copy()
    cv2.rectangle(overlay, (x, y), (x2, y2), (0, 0, 0), -1)
    cv2.addWeighted(overlay, alpha, image, 1 - alpha, 0, image)


def draw_wave_line_display(output_img, line_1d, color, height, thickness=2):
    if line_1d is None or len(line_1d) < 2:
        return
    points = np.column_stack((np.arange(len(line_1d)), np.clip(line_1d, 0, height - 1).astype(np.int32)))
    points = points.reshape((-1, 1, 2))
    cv2.polylines(output_img, [points], False, color, thickness)


def draw_centered_signal_panel_display(output_img, signal_1d, x, y, width, height, center_color, signal_color, max_amp_value):
    if signal_1d is None or len(signal_1d) < 2:
        return
    center_y = y + int(height * 0.5)
    cv2.line(output_img, (x, center_y), (x + width, center_y), center_color, 1)
    zoom_y = 2.0
    scale = zoom_y * (height * 0.45) / max(max_amp_value * 0.5, 1.0)
    x_coords = np.linspace(x, x + width - 1, len(signal_1d)).astype(np.int32)
    y_coords = np.clip(center_y + (signal_1d * scale), y, y + height - 1).astype(np.int32)
    points = np.column_stack((x_coords, y_coords)).reshape((-1, 1, 2))
    cv2.polylines(output_img, [points], False, signal_color, 2)


def compose_display_frame(payload, out_size):
    current_frame = payload['current_frame']
    wave_img = payload['wave_img']
    output = cv2.add(current_frame, wave_img)
    height, width = output.shape[:2]

    show_binary = payload['show_binary']
    show_mask = payload['show_mask']
    show_fill_blanks = payload['show_fill_blanks']
    show_medianfilter = payload['show_medianfilter']
    show_lowpassfilter = payload['show_lowpassfilter']
    show_finalwave = payload['show_finalwave']
    show_hex_grid = payload['show_hex_grid']
    show_option_panel = payload['show_option_panel']
    show_sine_spectrum = payload['show_sine_spectrum']
    show_stats = payload['show_stats']

    colors = payload['colors']

    if show_binary:
        binary_tint = np.zeros_like(output)
        binary_img = payload['binary_img']
        binary_tint[:, :, 0] = binary_img
        binary_tint[:, :, 1] = binary_img
        output = cv2.addWeighted(output, 1.0, binary_tint, 0.28, 0)

    if show_mask:
        cv2.polylines(output, pts=[payload['pts']], isClosed=True, color=(255, 0, 0), thickness=2)

    if show_fill_blanks:
        draw_wave_line_display(output, payload['wave_1D_filled'], colors['fill_blanks'], height, 4)
    if show_medianfilter:
        draw_wave_line_display(output, payload['wave_1D_median'], colors['median'], height, 3)
    if show_lowpassfilter:
        draw_wave_line_display(output, payload['wave_1D_lowpass'], colors['lowpass'], height, 2)
    if show_finalwave:
        draw_wave_line_display(output, payload['wave_1D_final'], colors['finalwave'], height, 2)

    mask_left = payload['mask_left']
    mask_right = payload['mask_right']
    roi_top_y = payload['roi_top_y']
    roi_bottom_y = payload['roi_bottom_y']
    descriptors = payload['descriptors']
    vertical_cog_y = payload['vertical_cog_y']
    roi_width_px = max(mask_right - mask_left, 1)
    shape_centroid_x_px = int(np.clip(mask_left + descriptors['shape_centroid_x'] * (roi_width_px - 1), mask_left, mask_right - 1))
    vertical_cog_y_px = int(np.clip(vertical_cog_y, roi_top_y, roi_bottom_y))
    cv2.line(output, (mask_left, vertical_cog_y_px), (mask_right, vertical_cog_y_px), colors['red'], 1)
    cv2.line(output, (shape_centroid_x_px, roi_top_y), (shape_centroid_x_px, roi_bottom_y), colors['red'], 3)

    if show_hex_grid:
        draw_hex_grid_overlay_module(
            output,
            payload['hex_active_cells'],
            payload['hex_orig_x'],
            payload['hex_orig_y'],
            payload['hex_size_x'],
            payload['hex_size_y'],
            (mask_left, mask_right, roi_top_y, roi_bottom_y),
            payload['hex_layout_idx'],
        )

    cog_label_font_scale = 0.825
    cog_label_thickness = 2
    cog_label_x = int(mask_right + 4)
    cog_label_text_y = int(np.clip(vertical_cog_y_px - 4, 20, height - 30))
    cog_label_value_y = int(np.clip(cog_label_text_y + 28, 32, height - 6))
    cv2.putText(output, 'cog', (cog_label_x, cog_label_text_y), cv2.FONT_HERSHEY_SIMPLEX, cog_label_font_scale, colors['red'], cog_label_thickness, cv2.LINE_AA)
    cv2.putText(output, f"{payload['vertical_cog_norm']:.2f}", (cog_label_x, cog_label_value_y), cv2.FONT_HERSHEY_SIMPLEX, cog_label_font_scale, colors['red'], cog_label_thickness, cv2.LINE_AA)

    centroid_label = f"cent {descriptors['shape_centroid_x']:.2f}"
    centroid_font_scale = 0.825
    centroid_thickness = 2
    (centroid_text_w, _), _ = cv2.getTextSize(centroid_label, cv2.FONT_HERSHEY_SIMPLEX, centroid_font_scale, centroid_thickness)
    centroid_label_x = int(np.clip(shape_centroid_x_px - centroid_text_w // 2, 4, width - centroid_text_w - 4))
    centroid_label_y = max(30, roi_top_y - 8)
    cv2.putText(output, centroid_label, (centroid_label_x, centroid_label_y), cv2.FONT_HERSHEY_SIMPLEX, centroid_font_scale, colors['red'], centroid_thickness, cv2.LINE_AA)

    v_offset = 24
    wave_activity_slider_width = 300
    if show_stats:
        wave_texts = payload['wave_texts']
        stats_lines = payload['stats_lines']
        (wave_activity_text_w, _), _ = cv2.getTextSize(wave_texts['activity'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        (wave_movement_text_w, _), _ = cv2.getTextSize(wave_texts['movement'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        (wave_amp_text_w, _), _ = cv2.getTextSize(wave_texts['amp'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        (wave_amp_comp_text_w, _), _ = cv2.getTextSize(wave_texts['amp_comp'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        (wave_curvature_text_w, _), _ = cv2.getTextSize(wave_texts['curvature'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        (wave_shape_text_w, _), _ = cv2.getTextSize(wave_texts['shape'], cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
        stats_panel_label_w = max(wave_activity_text_w, wave_movement_text_w, wave_amp_text_w, wave_amp_comp_text_w, wave_curvature_text_w, wave_shape_text_w)
        stats_panel_min_width = 20 + stats_panel_label_w + 14 + wave_activity_slider_width + 20
        stats_step = v_offset * 2
        stats_first_y = 25
        total_rows = len(stats_lines) + 6
        stats_panel_height = int((stats_first_y - 8) + ((total_rows - 1) * stats_step) + 18)
        stats_panel_width = max(int(width * 0.40), stats_panel_min_width)
        draw_transparent_rect_display(output, 8, 8, stats_panel_width, stats_panel_height, alpha=0.45)

    if show_option_panel:
        option_rows = payload['option_rows']
        option_box_width = 380
        option_box_height = 12 + len(option_rows) * v_offset
        option_box_x = width - option_box_width - 10
        option_box_y = 8
        draw_transparent_rect_display(output, option_box_x, option_box_y, option_box_width, option_box_height, alpha=0.45)
        legend_x = option_box_x + 10
        legend_y = option_box_y + 15
        for key_symbol, label, enabled, stage_color in option_rows:
            color = tuple(stage_color) if enabled else tuple(colors['toggle_gray'])
            cv2.circle(output, (legend_x, legend_y), 4, color, 4)
            cv2.putText(output, f'[{key_symbol}] {label}', (legend_x + 12, legend_y + 5), cv2.FONT_HERSHEY_SIMPLEX, 0.96, color, 1, cv2.LINE_AA)
            legend_y += v_offset

    if show_sine_spectrum:
        sine_display_values = payload['sine_display_values']
        sine_start_x = 16
        sine_step_x = 34
        sine_hm_x = sine_start_x + len(sine_display_values) * sine_step_x + 24
        sine_label_pad = 26
        sine_plot_height = payload['sine_display_height'] + sine_label_pad
        sine_panel_y = height - sine_plot_height - 56
        sine_base_y = sine_panel_y + sine_plot_height - 1
        sine_panel_width = (sine_hm_x - 8) + 40
        draw_transparent_rect_display(output, 8, sine_panel_y, sine_panel_width, sine_plot_height, alpha=0.35)
        sine_label_indices = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25}
        sine_cycles = payload['sine_display_cycles']
        sine_x_positions = sine_start_x + np.arange(len(sine_display_values)) * sine_step_x
        sine_bar_half_w = max(2, int(0.44 * sine_step_x))
        for i, sine_val in enumerate(sine_display_values):
            cycle = sine_cycles[i]
            sine_color = tuple(colors['orange']) if cycle < 3.0 else tuple(colors['green'])
            bar_height = max(1, int(sine_val * sine_plot_height))
            x = int(sine_x_positions[i])
            cv2.rectangle(output, (x - sine_bar_half_w, sine_base_y), (x + sine_bar_half_w, sine_base_y - bar_height), sine_color, -1)
            if i in sine_label_indices:
                cv2.putText(output, f'{cycle:g}', (x - 8, sine_base_y + 21), cv2.FONT_HERSHEY_SIMPLEX, 0.7, sine_color, 1, cv2.LINE_AA)
        spectral_centroid_cycle_clip = float(np.clip(payload['spectral_centroid_cycles'], float(sine_cycles[0]), float(sine_cycles[-1])))
        spectral_centroid_x = int(np.interp(spectral_centroid_cycle_clip, sine_cycles, sine_x_positions))
        cv2.line(output, (spectral_centroid_x, sine_base_y), (spectral_centroid_x, sine_base_y - sine_plot_height), tuple(colors['red']), 2)
        cv2.putText(output, 'cent', (spectral_centroid_x - 14, sine_base_y - sine_plot_height - 6), cv2.FONT_HERSHEY_SIMPLEX, 0.55, tuple(colors['red']), 1, cv2.LINE_AA)
        hf_height = max(1, int(payload['sine_highmode_norm'] * sine_plot_height))
        cv2.line(output, (sine_hm_x, sine_base_y), (sine_hm_x, sine_base_y - hf_height), tuple(colors['red']), 3)
        cv2.putText(output, 'HM', (sine_hm_x - 16, sine_base_y + 22), cv2.FONT_HERSHEY_SIMPLEX, 1.05, tuple(colors['red']), 1, cv2.LINE_AA)

    if show_stats:
        wave_texts = payload['wave_texts']
        stats_lines = payload['stats_lines']
        stats_x = 20
        stats_y = 25
        slider_x = stats_x + payload['stats_panel_label_w'] + 14
        slider_h = 14
        cv2.putText(output, wave_texts['activity'], (stats_x, stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, tuple(colors['stats']), 1, cv2.LINE_AA)
        slider_y = stats_y - 13
        wave_activity_norm = float(np.clip(payload['wave_activity'], 0.0, 1.0))
        slider_fill_w = int(round(wave_activity_norm * wave_activity_slider_width))
        cv2.rectangle(output, (slider_x, slider_y), (slider_x + wave_activity_slider_width, slider_y + slider_h), tuple(colors['stats']), 1)
        if slider_fill_w > 0:
            cv2.rectangle(output, (slider_x, slider_y), (slider_x + slider_fill_w, slider_y + slider_h), tuple(colors['stats']), -1)
        stats_y += v_offset * 2
        move_color = tuple(colors['green']) if payload['wave_motion_value'] < 0.0 else tuple(colors['red']) if payload['wave_motion_value'] > 0.0 else tuple(colors['stats'])
        cv2.putText(output, wave_texts['movement'], (stats_x, stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, move_color, 1, cv2.LINE_AA)
        move_slider_y = stats_y - 13
        move_center_x = slider_x + (wave_activity_slider_width // 2)
        move_norm = float(np.clip(payload['wave_motion_value'] / payload['wave_motion_slider_max'], -1.0, 1.0))
        move_fill_half = int(round(abs(move_norm) * (wave_activity_slider_width // 2)))
        cv2.rectangle(output, (slider_x, move_slider_y), (slider_x + wave_activity_slider_width, move_slider_y + slider_h), tuple(colors['stats']), 1)
        cv2.line(output, (move_center_x, move_slider_y), (move_center_x, move_slider_y + slider_h), tuple(colors['stats']), 1)
        if move_fill_half > 0:
            if move_norm >= 0.0:
                cv2.rectangle(output, (move_center_x, move_slider_y), (move_center_x + move_fill_half, move_slider_y + slider_h), move_color, -1)
            else:
                cv2.rectangle(output, (move_center_x - move_fill_half, move_slider_y), (move_center_x, move_slider_y + slider_h), move_color, -1)
        stats_y += v_offset * 2
        for key_name, divisor in [('amp', 1.0), ('amp_comp', 2.0), ('curvature', 2.0)]:
            cv2.putText(output, wave_texts[key_name], (stats_x, stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, tuple(colors['stats']), 1, cv2.LINE_AA)
            slider_y = stats_y - 13
            value = payload['wave_amp'] if key_name == 'amp' else payload['amp_comp'] if key_name == 'amp_comp' else payload['curvature_rms']
            norm = float(np.clip(value / divisor, 0.0, 1.0))
            fill_w = int(round(norm * wave_activity_slider_width))
            cv2.rectangle(output, (slider_x, slider_y), (slider_x + wave_activity_slider_width, slider_y + slider_h), tuple(colors['stats']), 1)
            if fill_w > 0:
                cv2.rectangle(output, (slider_x, slider_y), (slider_x + fill_w, slider_y + slider_h), tuple(colors['stats']), -1)
            stats_y += v_offset * 2
        shape_color = tuple(colors['green']) if payload['shape_state_label'] == 'periodic' else tuple(colors['red']) if payload['shape_state_label'] == 'endpoint-lost' else tuple(colors['orange']) if payload['shape_state_label'] == 'arc' else tuple(colors['light_blue']) if payload['shape_state_label'] == 'straight' else tuple(colors['yellow']) if payload['shape_state_label'] == 'one-bump' else tuple(colors['stats'])
        cv2.putText(output, wave_texts['shape'], (stats_x, stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, shape_color, 1, cv2.LINE_AA)
        stats_y += v_offset * 2
        for line in stats_lines:
            cv2.putText(output, line, (stats_x, stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, tuple(colors['stats']), 1, cv2.LINE_AA)
            stats_y += v_offset * 2

    output = cv2.resize(output, out_size)
    return output


def draw_hex_grid_overlay_module(img, active_cells, ox, oy, size_x, size_y, roi_bounds, layout_idx):
    rl, rr, rt, rb = roi_bounds
    layout_name, dq, dr = HEX_LAYOUTS[layout_idx]
    draw_sx = size_x * 0.90
    draw_sy = size_y * 0.90
    q_min = int(np.floor((2.0 / 3.0) * (rl - ox) / size_x)) - 1
    q_max = int(np.ceil((2.0 / 3.0) * (rr - ox) / size_x)) + 1
    for q in range(q_min, q_max + 1):
        cy_q = oy + size_y * _HEX_SQRT3 * 0.5 * q
        r_min = int(np.floor((rt - cy_q) / (size_y * _HEX_SQRT3))) - 1
        r_max = int(np.ceil((rb - cy_q) / (size_y * _HEX_SQRT3))) + 1
        for r in range(r_min, r_max + 1):
            cx, cy = _hex_center_px(q, r, ox, oy, size_x, size_y)
            if not (rl - size_x < cx < rr + size_x and rt - size_y < cy < rb + size_y):
                continue
            active = (q, r) in active_cells
            color = (50, 220, 255) if active else (80, 80, 100)
            cv2.polylines(img, [_hex_verts(cx, cy, draw_sx, draw_sy)], True, color, 2 if active else 1)
            offset = q * dq + r * dr
            cv2.putText(img, str(offset), (int(cx) - 7, int(cy) + 4), cv2.FONT_HERSHEY_SIMPLEX, 0.28, color, 1, cv2.LINE_AA)
    cv2.putText(img, f'hex:{layout_name}', (rl, max(rt - 4, 14)), cv2.FONT_HERSHEY_SIMPLEX, 0.52, (80, 80, 100), 1, cv2.LINE_AA)


def main():
    parser = argparse.ArgumentParser(description='Rope tracker with optional ATEM calibration')
    parser.add_argument('--skip-init-calibration', action='store_true', help='Skip startup ATEM calibration')
    parser.add_argument('--use-recorded-video', action='store_true', help='Use test_video.avi instead of live camera input and loop playback')
    args = parser.parse_args()
    
    
    def ensure_bgr_frame(frame):
        if frame is None:
            return None
        if len(frame.shape) == 2:
            return cv2.cvtColor(frame, cv2.COLOR_GRAY2BGR)
        return frame
    
    
    def prepare_frame(frame):
        frame = ensure_bgr_frame(frame)
        if flip:
            return cv2.flip(frame, -1)
        return frame
    
    
    def read_source_frame(capture, loop_video=False):
        ret, frame = capture.read()
        if ret:
            return True, ensure_bgr_frame(frame)
        if loop_video:
            capture.set(cv2.CAP_PROP_POS_FRAMES, 0)
            ret, frame = capture.read()
            if ret:
                print('Looping recorded test video.')
                return True, ensure_bgr_frame(frame)
        return False, None
    
    
    def create_video_writer(frame_width, frame_height):
        fourcc_options = ('MJPG', 'XVID')
        for fourcc_name in fourcc_options:
            fourcc = cv2.VideoWriter_fourcc(*fourcc_name)
            writer = cv2.VideoWriter(str(test_video_path), fourcc, fps, (frame_width, frame_height), isColor=False)
            if writer.isOpened():
                print(f'Recording to {test_video_path.name} using codec {fourcc_name}.')
                return writer
            writer.release()
        return None
    
    
    def start_recording(raw_frame):
        writer = create_video_writer(raw_frame.shape[1], raw_frame.shape[0])
        if writer is None:
            print('Could not open video writer for recording.')
            return None, None
        return writer, time.time()
    
    
    def stop_recording(record_writer, reason='stopped'):
        if record_writer is not None:
            record_writer.release()
            print(f'Recording {reason}. Saved to {test_video_path.name}.')
        return None, None
    
    
    def screen_blend_self(img):
        """Screen-blend an image with itself to normalize brightness across regions."""
        f = img.astype(np.float32) / 255.0
        return ((1.0 - (1.0 - f) * (1.0 - f)) * 255.0).astype(np.uint8)
    
    
    def lowpass_over_time(current_gray, alpha, prev_float):
        """Exponential moving-average background model.
        Returns (background_uint8, updated_float_accumulator)."""
        cur_f = current_gray.astype(np.float32)
        new_f = alpha * cur_f + (1.0 - alpha) * prev_float
        return new_f.astype(np.uint8), new_f
    
    
    def run_atem_calibration(mode='static'):
        if (not atem_enable_calibration) or (run_auto_calibration is None):
            print(f'ATEM calibration skipped: enabled={atem_enable_calibration}, available={run_auto_calibration is not None}')
            return
    
        sample_seconds = atem_sample_seconds_static if mode == 'static' else atem_sample_seconds_motion
        result, status = run_auto_calibration(
            atem_ip=atem_ip,
            camera=atem_camera_input,
            video_device=video_device,
            collect_seconds=atem_collect_seconds,
            gain_values=atem_gain_values,
            settle_seconds=atem_settle_seconds,
            sample_seconds=sample_seconds,
            mode=mode,
            strategy='extended',
            fallback_simple=True,
            apply_best=True,
            verbose=True,
        )
        if status != 0:
            print(f'ATEM calibration ({mode}) failed:', json.dumps(result))
            return
    
        summary = {
            'mode': mode,
            'current_iso': result.get('current_iso'),
            'best_iso': result.get('best_iso'),
            'applied_iso': result.get('applied_iso'),
        }
        print('ATEM calibration complete:', json.dumps(summary))
    
    
    if args.use_recorded_video and (not test_video_path.exists()):
        raise SystemExit(f'Recorded video not found: {test_video_path}')
    
    if args.use_recorded_video and (not args.skip_init_calibration):
        print('Startup ATEM calibration skipped in recorded-video mode.')
    elif atem_enable_calibration and (not args.skip_init_calibration):
        print('Running startup ATEM calibration (static baseline)...')
        run_atem_calibration(mode='static')
    elif args.skip_init_calibration:
        print('Startup ATEM calibration skipped by command line argument.')
    
    capture_source = str(test_video_path) if args.use_recorded_video else video_device
    cap = cv2.VideoCapture(capture_source)
    ret, raw_current_frame = read_source_frame(cap, loop_video=args.use_recorded_video)
    if not ret:
        raise SystemExit(f'Could not open video source: {capture_source}')
    current_frame = prepare_frame(raw_current_frame)
    previous_frame_gray = cv2.cvtColor(current_frame, cv2.COLOR_BGR2GRAY)
    prev_frame_float = previous_frame_gray.astype(np.float32)
    dimensions = current_frame.shape
    print(dimensions)
    
    # output size
    scale = displaysize/np.shape(current_frame)[1] # data array shape is y,x
    size = (displaysize,int(np.shape(current_frame)[0]*scale))
    
    # flip
    # lowpass filter preprocess
    nyquist = 0.5 * dimensions[0]
    normal_cutoff = 12 / nyquist  # 0.6x original cutoff: smoother spatial lowpass
    order = 1
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    
    # mask etc
    mask = np.zeros(dimensions[:2], dtype="uint8")
    pts = np.array([[int(dimensions[1]*mask_up_left[0]),int(dimensions[0]*mask_up_left[1])],
                    [int(dimensions[1]*mask_up_right[0]),int(dimensions[0]*mask_up_right[1])],
                    [int(dimensions[1]*mask_lo_right[0]),int(dimensions[0]*mask_lo_right[1])],
                    [int(dimensions[1]*mask_lo_left[0]),int(dimensions[0]*mask_lo_left[1])]], np.int32)
    max_amp = np.max(pts[:,1])-np.min(pts[:,1])
    pts = pts.reshape((-1,1,2))
    polyg = cv2.fillPoly(mask,pts=[pts],color=255)
    # print mask center y left and center y right
    print(pts[0][0][1],pts[3][0][1])
    wavecenter_y_left = np.max([pts[0][0][1],pts[3][0][1]]) - int(abs(pts[0][0][1]-pts[3][0][1])*0.5)
    wavecenter_y_right = np.max([pts[1][0][1],pts[2][0][1]]) - int(abs(pts[1][0][1]-pts[2][0][1])*0.5)
    print('wavecenter', wavecenter_y_left, wavecenter_y_right)
    mask_center = np.linspace(wavecenter_y_left, wavecenter_y_right, dimensions[1])
    mask_left = pts[0][0][0] # left top, assumes vertical left edge
    mask_right = pts[1][0][0] # right top, as above
    roi_top_y = int(min(pts[0][0][1], pts[1][0][1]))
    roi_bottom_y = int(max(pts[2][0][1], pts[3][0][1]))
    print('mask LR', mask_left, mask_right)
    send_counter = 0
    max_numpeaks = 0
    numpeaks_median_value = 0
    numpeaks_lowpass_value = 0.0
    numpeaks_history = deque(maxlen=numpeaks_median_window_frames)
    prev_wave_1D = np.zeros(dimensions[1])
    remembered_left_endpoint_y = float(wavecenter_y_left)
    remembered_right_endpoint_y = float(wavecenter_y_right)
    remembered_left_outside_y = float(wavecenter_y_left)
    remembered_right_outside_y = float(wavecenter_y_right)
    prev_roi_wave_motion = None
    prev_binary_img = np.copy(previous_frame_gray)
    spectral_centroid_cycles = 0.0
    spectral_centroid_norm = 0.0
    vertical_cog_y = float(np.mean(mask_center[mask_left:mask_right]))
    vertical_cog_norm = float(np.clip(vertical_cog_y / max(dimensions[0] - 1, 1), 0.0, 1.0))
    wave_activity = 0.0
    wave_amp = 0.0
    amp_comp = 0.0
    curvature_rms = 0.0
    wave_motion_value = 0.0
    avg_x_distance = 0
    avg_x_movement = 0
    prev_shape_centroid_x = 0.5
    shape_state_id = len(shape_state_labels) - 1
    shape_state_label = shape_state_labels[shape_state_id]
    shape_state_confidence = 0.0
    shape_state_scores = np.zeros(len(shape_state_labels), dtype=np.float32)
    shape_state_scores[shape_state_id] = 1.0
    x_pos = np.zeros(0)
    x_distances = np.zeros(0)
    record_writer = None
    record_started_time = None
    record_overwrite_armed = False
    display_update_stride = 1
    display_compose_in_worker = True
    display_frame_counter = 0
    underflow_event_count = 0
    underflow_deficit_ms_total = 0.0
    underflow_avg_ms_per_sec = 0.0
    underflow_event_rate_per_sec = 0.0
    underflow_window_start = 0.0
    perf_frame_count = 0
    perf_display_frame_count = 0
    perf_skip_frame_count = 0
    perf_proc_ms_total = 0.0
    perf_display_proc_ms_total = 0.0
    perf_skip_proc_ms_total = 0.0
    perf_freq_frame_count = 0
    perf_freq_proc_ms_total = 0.0
    perf_window_start = 0.0
    display_frame_queue = None
    display_key_queue = None
    display_stop_event = None
    display_process = None
    display_skipped_total = 0
    display_skipped_current = 0
    
    # BGR colors
    red = (0,0,255)
    blue = (255,0,0)
    green = (0,255,0)
    yellow = (0,255,255)
    pink = (255,0,255)
    light_blue = (255,255,0)
    orange = (0,128,255)
    light_green = (204,255,153)
    purple = (255,102,178)
    light_pink = (204,153,255)
    dull_green = (0,128,0)
    dull_red = (0,0,128)
    
    centroid_color = purple
    fill_blanks_color = yellow
    lowpass_color = orange
    wavecenter_color = dull_green
    wavesign_color = dull_red
    peaknegative_color = red
    peakplus_color = green
    stats_color = yellow
    fader_color = purple
    
    show_binary = True
    show_centroid = False
    show_fill_blanks = True
    show_medianfilter = True
    show_lowpassfilter = True
    show_wavecenter = True
    show_finalwave = True
    show_wavesign = False
    show_mask = True
    show_peaks = True
    show_stats = True
    show_faders = True
    show_sine_spectrum = True
    show_option_panel = True
    show_hex_grid = False
    hex_active_cells = set()
    paused = False
    use_bg_model = True       # combine background-model diff with per-frame diff
    use_screen_blend = False   # screen-blend equalization before threshold
    use_kinematic_constraint = True
    rope_is_darker = True     # True: rope darker than background, False: rope lighter than background
    
    toggle_gray = (128,128,128)
    median_color = light_blue
    finalwave_color = pink
    
    binary_option_color = (255,255,255)
    filled_option_color = (0,255,255)
    median_option_color = (255,255,0)
    lowpass_option_color = (0,180,255)
    final_option_color = (255,0,255)
    center_option_color = (0,255,0)
    option_stats_color = (180,255,120)
    bg_model_option_color = (255,180,60)   # warm amber
    screen_blend_option_color = (180,120,255)  # soft purple
    kinematic_option_color = (120,220,255)
    polarity_option_color = (255,210,180)
    # hex grid overlay colors
    hex_grid_dim_color    = (80, 80, 100)      # BGR: dim lines for inactive cells
    hex_grid_active_color = (50, 220, 255)     # BGR: bright highlight for active cells
    display_colors = {
        'red': red,
        'green': green,
        'yellow': yellow,
        'orange': orange,
        'light_blue': light_blue,
        'dull_green': dull_green,
        'fill_blanks': fill_blanks_color,
        'median': median_color,
        'lowpass': lowpass_color,
        'finalwave': finalwave_color,
        'stats': stats_color,
        'toggle_gray': toggle_gray,
    }
    sine_selected_prev = np.zeros(len(sine_display_cycles), dtype=np.float32)
    sine_fluctuation_history = deque(maxlen=max(5, int(round(fps * 0.8))))
    
    def find_center_wave_regr(wave_1D, mask_left, mask_right):
        x = np.arange(0,len(wave_1D[mask_left:mask_right]),1)
        m, c = np.polyfit(x, wave_1D[mask_left:mask_right], 1)
        regr = np.linspace(c,c+len(wave_1D[mask_left:mask_right])*m,len(wave_1D[mask_left:mask_right]))
        centr = np.zeros(len(wave_1D))
        centr[:mask_left] = regr[0]
        centr[mask_left:mask_right] = regr
        centr[mask_right:] = regr[-1]
        return centr
    
    def centroid_1D_from_img(input_img, output_img, show_centroid, centroid_color):
        # centroid
        centroid_1D = np.zeros(dimensions[1])
        obs_count_1D = np.zeros(dimensions[1])
        for i in range(dimensions[1]):
            y_coords = np.nonzero(input_img[:,i])
            count = len(y_coords[0])
            if count > 0:
                y_centroid = np.mean(y_coords)
                y_centroid = int(np.round(y_centroid))
                centroid_1D[i] = y_centroid
                obs_count_1D[i] = count
                if show_centroid:
                    cv2.circle(output_img, (i,y_centroid),5, centroid_color, 1)# display centroid
        return centroid_1D, obs_count_1D
    
    
    def constrain_centroid_by_rope_kinematics(centroid_1D, obs_count_1D, prev_wave_1D, left_limit, right_limit):
        constrained = np.copy(centroid_1D)
        if right_limit <= left_limit:
            return constrained
    
        has_prev_wave = np.any(prev_wave_1D[left_limit:right_limit] > 0)
    
        def pass_once(start_x, end_x, step):
            out = np.zeros_like(centroid_1D)
            last_good_x = None
            last_good_y = 0.0
            for x in range(start_x, end_x, step):
                y = centroid_1D[x]
                if y <= 0:
                    continue
                if has_prev_wave and abs(y - prev_wave_1D[x]) > max_temporal_deviation_px:
                    continue
                if last_good_x is not None:
                    dx = abs(x - last_good_x)
                    allowed_jump = max_spatial_jump_px + dx
                    if abs(y - last_good_y) > allowed_jump:
                        continue
                out[x] = y
                last_good_x = x
                last_good_y = y
            return out
    
        forward = pass_once(left_limit, right_limit, 1)
        backward = pass_once(right_limit - 1, left_limit - 1, -1)
        both_mask = (forward > 0) & (backward > 0)
        constrained[left_limit:right_limit] = 0
        constrained[both_mask] = 0.5 * (forward[both_mask] + backward[both_mask])
        constrained[(forward > 0) & (backward == 0)] = forward[(forward > 0) & (backward == 0)]
        constrained[(backward > 0) & (forward == 0)] = backward[(backward > 0) & (forward == 0)]
    
        # Re-attach strong binary observations if kinematic pass drifts too far,
        # with extra trust near left/right edges where extrapolation errors are most visible.
        right_edge_start = right_limit - kinematic_edge_anchor_px
        for x in range(left_limit, right_limit):
            y_obs = centroid_1D[x]
            if y_obs <= 0:
                continue
            obs_is_strong = obs_count_1D[x] >= kinematic_min_obs_pixels
            in_edge_zone = (x - left_limit) < kinematic_edge_anchor_px or x >= right_edge_start
            if in_edge_zone:
                if obs_is_strong and (not has_prev_wave or abs(y_obs - prev_wave_1D[x]) <= max_temporal_deviation_px):
                    constrained[x] = y_obs
                continue
            if not obs_is_strong:
                continue
            y_cons = constrained[x]
            if y_cons <= 0 or abs(y_cons - y_obs) > kinematic_snap_to_obs_px:
                constrained[x] = y_obs
        return constrained
    
    def update_endpoint_memory(centroid_1D, obs_count_1D, left_memory_y, right_memory_y):
        strong_obs = np.where((centroid_1D > 0) & (obs_count_1D >= endpoint_memory_min_obs_pixels))[0]
        if len(strong_obs) == 0:
            return left_memory_y, right_memory_y
        left_memory_y = float(centroid_1D[int(strong_obs[0])])
        right_memory_y = float(centroid_1D[int(strong_obs[-1])])
        return left_memory_y, right_memory_y
    
    def update_outside_anchor_memory(centroid_1D, obs_count_1D, left_limit, right_limit, left_outside_y, right_outside_y):
        strong_obs = np.where((centroid_1D > 0) & (obs_count_1D >= endpoint_memory_min_obs_pixels))[0]
        if len(strong_obs) == 0:
            return left_outside_y, right_outside_y
        left_candidates = strong_obs[strong_obs < left_limit]
        right_candidates = strong_obs[strong_obs >= right_limit]
        if len(left_candidates) > 0:
            left_outside_y = float(centroid_1D[int(left_candidates[-1])])
        if len(right_candidates) > 0:
            right_outside_y = float(centroid_1D[int(right_candidates[0])])
        return left_outside_y, right_outside_y
    
    def fill_in_missing_points(y_init_left, y_init_right, input_1D, output_1D, output_img, show_fill_blanks, fill_blanks_color):
        valid_points = np.where(input_1D > 0)[0]
        if len(valid_points) == 0:
            output_1D[:dimensions[1]] = np.linspace(y_init_left, y_init_right, dimensions[1])
            if show_fill_blanks:
                for i in range(mask_left,mask_right):
                    cv2.circle(output_img, (i,int(output_1D[i])), 3, fill_blanks_color, 1)
            return output_1D
    
        # fill in missing points
        x_prev = 0
        y_prev = y_init_left
        savepoint = 0
        firstpoint = [] # for filling filter padding to the left
        create_line = 0
        first_point = 0
        for i in range(dimensions[1]):
            y_value = input_1D[i]
            if first_point == 0:
                if input_1D[i] == 0:
                    y_value = y_init_left
                else:
                    first_point = 1
            if y_value == 0:
                if savepoint == 0:
                    x_prev = i
                    create_line = 1
                savepoint = 1
            else: 
                if firstpoint == []: 
                    firstpoint = [i,y_value]
                if create_line > 0:
                    line_len = i-x_prev
                    line = np.linspace(y_prev, y_value, line_len)
                    #print('create_line', i, y_prev, y_value)
                    output_1D[x_prev:i] = np.reshape(line, shape=(line_len,))
                    create_line = 0
                #print('write y_value', i, y_value)
                output_1D[i] = y_value
                y_prev = y_value
                savepoint = 0
        # Fill the tail only if the array actually ended inside a blank segment.
        # Otherwise this can overwrite valid observed points near the right side.
        if savepoint == 1:
            line_len = dimensions[1] - x_prev
            line = np.linspace(y_init_right, y_init_right, line_len)
            output_1D[x_prev:dimensions[1]] = np.reshape(line, shape=(line_len,))
        if show_fill_blanks:
            for i in range(mask_left,mask_right):
                cv2.circle(output_img, (i,int(output_1D[i])), 3, fill_blanks_color, 1)
        return output_1D
    
    def lowpass_1D(input_1D, output_img, show_lowpassfilter, lowpass_color):
        input_1D = lfilter(b, a, input_1D)
        if show_lowpassfilter:
            for i in range(mask_left,mask_right):
                cv2.circle(output_img, (i,int(input_1D[i])), 4, lowpass_color, 1)
        return input_1D
    
    
    def draw_transparent_rect(image, x, y, width, height, alpha=0.45):
        x = max(0, int(x))
        y = max(0, int(y))
        width = max(1, int(width))
        height = max(1, int(height))
        x2 = min(image.shape[1], x + width)
        y2 = min(image.shape[0], y + height)
        if x2 <= x or y2 <= y:
            return
        overlay = image.copy()
        cv2.rectangle(overlay, (x, y), (x2, y2), (0, 0, 0), -1)
        cv2.addWeighted(overlay, alpha, image, 1 - alpha, 0, image)
    
    
    def draw_wave_line(output_img, line_1d, color, thickness=2):
        if line_1d is None or len(line_1d) < 2:
            return
        points = np.column_stack((np.arange(len(line_1d)), np.clip(line_1d, 0, dimensions[0]-1).astype(np.int32)))
        points = points.reshape((-1, 1, 2))
        cv2.polylines(output_img, [points], False, color, thickness)
    
    def draw_centered_signal_panel(output_img, signal_1d, x, y, width, height, center_color, signal_color):
        if signal_1d is None or len(signal_1d) < 2:
            return
        center_y = y + int(height * 0.5)
        cv2.line(output_img, (x, center_y), (x + width, center_y), center_color, 1)
        zoom_y = 2.0
        scale = zoom_y * (height * 0.45) / max(max_amp * 0.5, 1.0)
        x_coords = np.linspace(x, x + width - 1, len(signal_1d)).astype(np.int32)
        y_coords = np.clip(center_y + (signal_1d * scale), y, y + height - 1).astype(np.int32)
        points = np.column_stack((x_coords, y_coords)).reshape((-1, 1, 2))
        cv2.polylines(output_img, [points], False, signal_color, 2)
    
    def fit_spatial_sine_bank(signal_1d, cycle_bank, x_norm=None):
        """Finite-interval sine fit returning baseline-improvement component amplitude per cycle."""
        if signal_1d is None or cycle_bank is None:
            return np.zeros(0, dtype=np.float32), np.zeros(0, dtype=np.float32)
        num_points = len(signal_1d)
        if num_points < 4 or len(cycle_bank) == 0:
            return np.zeros(len(cycle_bank), dtype=np.float32), np.zeros(len(cycle_bank), dtype=np.float32)

        signal_f = signal_1d.astype(np.float32)
        if x_norm is None:
            x_use = np.linspace(0.0, 1.0, num_points, dtype=np.float32)
        else:
            x_use = np.asarray(x_norm, dtype=np.float32)
            if len(x_use) != num_points:
                return np.zeros(len(cycle_bank), dtype=np.float32), np.zeros(len(cycle_bank), dtype=np.float32)
        ones = np.ones(num_points, dtype=np.float32)

        component_amplitudes = np.zeros(len(cycle_bank), dtype=np.float32)
        fit_mse = np.zeros(len(cycle_bank), dtype=np.float32)

        baseline_design = np.column_stack((ones, x_use))
        baseline_coeffs, _, _, _ = np.linalg.lstsq(baseline_design, signal_f, rcond=None)
        baseline_fit = baseline_design @ baseline_coeffs

        for idx, cycles in enumerate(cycle_bank):
            omega = float(2.0 * np.pi * cycles)
            sin_col = np.sin(omega * x_use).astype(np.float32)
            cos_col = np.cos(omega * x_use).astype(np.float32)
            design = np.column_stack((ones, x_use, sin_col, cos_col))

            coeffs, _, _, _ = np.linalg.lstsq(design, signal_f, rcond=None)
            fit = design @ coeffs

            sine_component = fit - baseline_fit
            component_amplitudes[idx] = float(np.sqrt(np.mean(sine_component * sine_component)) * np.sqrt(2.0))
            fit_mse[idx] = float(np.mean((signal_f - fit) ** 2))

        return component_amplitudes, fit_mse


    def compute_observed_sine_spectrum(roi_wave, roi_obs_mask, cycle_bank):
        roi_wave_full = np.asarray(roi_wave, dtype=np.float32)
        obs_mask = np.asarray(roi_obs_mask, dtype=bool)
        if len(roi_wave_full) < 4 or len(obs_mask) != len(roi_wave_full) or not np.any(obs_mask):
            return np.zeros(len(cycle_bank), dtype=np.float32), np.zeros(0, dtype=np.float32)

        x_obs = np.nonzero(obs_mask)[0].astype(np.float32)
        y_obs = roi_wave_full[obs_mask]
        if len(x_obs) < 4:
            return np.zeros(len(cycle_bank), dtype=np.float32), np.zeros(0, dtype=np.float32)

        slope, intercept = np.polyfit(x_obs, y_obs, 1)
        center_obs = (slope * x_obs) + intercept
        sine_input = (y_obs - center_obs).astype(np.float32)

        obs_span = max(float(x_obs[-1] - x_obs[0]), 1.0)
        x_norm_obs = (x_obs - x_obs[0]) / obs_span
        sine_selected, _sine_fit_mse = fit_spatial_sine_bank(sine_input, cycle_bank, x_norm_obs)
        return sine_selected, sine_input
    
    def extract_wave_features(input_1D, center_wave, left_limit, right_limit, output_img, show_wavesign, wavesign_color, show_wavecenter, wavecenter_color):
        roi_width = max(right_limit-left_limit, 1)
        residual = input_1D - center_wave
        amplitude_threshold = max_amp * peak_min_amplitude_frac
        prominence_threshold = max_amp * peak_min_prominence_frac
        min_peak_distance = max(2, int(round(roi_width * peak_min_distance_frac)))
    
        residual_roi = residual[left_limit:right_limit]
        pos_peaks, _ = scipy_find_peaks(
            residual_roi,
            height=amplitude_threshold,
            prominence=prominence_threshold,
            distance=min_peak_distance,
        )
        neg_peaks, _ = scipy_find_peaks(
            -residual_roi,
            height=amplitude_threshold,
            prominence=prominence_threshold,
            distance=min_peak_distance,
        )
        peak_indices = np.array(sorted(np.concatenate((pos_peaks, neg_peaks)).astype(np.int32))) + left_limit
    
        sign = np.zeros_like(residual)
        sign[residual > amplitude_threshold] = 1
        sign[residual < -amplitude_threshold] = -1
        for i in range(left_limit, right_limit):
            if show_wavesign:
                y = int((sign[i] * 150) + center_wave[i])
                cv2.circle(output_img, (i, y), 2, wavesign_color, 1)
            if show_wavecenter:
                cv2.circle(output_img, (i, int(center_wave[i])), 1, wavecenter_color, 1)
    
        def interpolate_zero_crossing(x_start, x_end, search_from_right=False):
            if x_end <= x_start:
                return None
            segment = residual[x_start:x_end + 1]
            if len(segment) < 2:
                return None
            segment_sign = np.sign(segment)
            crossing_candidates = np.where(segment_sign[:-1] * segment_sign[1:] <= 0)[0]
            if len(crossing_candidates) == 0:
                return None
            cross_idx = int(crossing_candidates[-1] if search_from_right else crossing_candidates[0])
            x0 = x_start + cross_idx
            y0 = segment[cross_idx]
            y1 = segment[cross_idx + 1]
            if y1 != y0:
                return x0 + float(-y0 / (y1 - y0))
            return float(x0)
    
        zero_crossings = []
        if len(peak_indices) > 0:
            left_edge_crossing = interpolate_zero_crossing(left_limit, int(peak_indices[0]), search_from_right=True)
            if left_edge_crossing is not None:
                zero_crossings.append((left_edge_crossing - left_limit) / roi_width)
    
        for i in range(len(peak_indices) - 1):
            left_peak = int(peak_indices[i])
            right_peak = int(peak_indices[i + 1])
            left_val = residual[left_peak]
            right_val = residual[right_peak]
            if left_val == 0 or right_val == 0 or np.sign(left_val) == np.sign(right_val):
                continue
            crossing_x = interpolate_zero_crossing(left_peak, right_peak)
            if crossing_x is None:
                segment = residual[left_peak:right_peak + 1]
                crossing_x = float(left_peak + np.argmin(np.abs(segment)))
            zero_crossings.append((crossing_x - left_limit) / roi_width)
    
        if len(peak_indices) > 0:
            right_edge_crossing = interpolate_zero_crossing(int(peak_indices[-1]), right_limit - 1, search_from_right=False)
            if right_edge_crossing is not None:
                zero_crossings.append((right_edge_crossing - left_limit) / roi_width)
    
        zero_crossings = np.array(sorted(zero_crossings), dtype=np.float32)
        return peak_indices.tolist(), zero_crossings
    
    def display_peaks(peak_indices, center_wave, input_1D, output_img, show_peaks, peakplus_color, peaknegative_color):
        for x in peak_indices:
            y = int(input_1D[x])
            if show_peaks:
                if y > center_wave[x]:
                    cv2.circle(output_img, (x,y), 14, peakplus_color, 8)
                else:
                    cv2.circle(output_img, (x,y), 14, peaknegative_color, 8)
     
    def compute_peak_descriptors(peak_indices, wave_1D, center_wave, roi_centerline, mask_left, mask_right, max_amp, prev_shape_centroid_x, shape_floor_frac, shape_gamma, shape_offcenter_pow):
        roi_width = max(mask_right-mask_left, 1)
        peak_positions = [peak for peak in peak_indices if mask_left <= peak <= mask_right]
        peak_positions = np.array(sorted(peak_positions), dtype=np.int32)
        numpeaks = len(peak_positions)
    
        if numpeaks > 1:
            avg_x_distance = float((peak_positions[-1]-peak_positions[0]) / ((numpeaks-1) * roi_width))
            x_distances = np.diff(peak_positions) / roi_width
        else:
            avg_x_distance = 0.0
            x_distances = np.zeros(0)
    
        if numpeaks > 0:
            x_pos = (peak_positions-mask_left) / roi_width
            peak_heights = np.abs((wave_1D[peak_positions]-center_wave[peak_positions]) / (max_amp*0.5))
            left_lobe_x = float(x_pos[0])
            right_lobe_x = float(x_pos[-1])
            max_lobe_x = float(x_pos[np.argmax(peak_heights)])
        else:
            x_pos = np.zeros(0)
            left_lobe_x = 0.0
            right_lobe_x = 0.0
            max_lobe_x = 0.0
    
        shape_slice = np.abs(wave_1D[mask_left:mask_right] - roi_centerline)
        if np.sum(shape_slice) > 0:
            shape_x = np.arange(mask_right-mask_left) / roi_width
            floor_frac = float(np.clip(shape_floor_frac, 0.0, 1.00))
            gamma = float(np.clip(shape_gamma, 0.25, 12.0))
            floor_px = max(0.0, float(max_amp) * floor_frac)
            shape_weight = np.maximum(shape_slice - floor_px, 0.0)
            if np.sum(shape_weight) <= 0:
                shape_centroid_target = prev_shape_centroid_x
            else:
                shape_weight = np.power(shape_weight, gamma)
                shape_centroid_target = float(np.sum(shape_x * shape_weight) / np.sum(shape_weight))
            offpow = float(np.clip(shape_offcenter_pow, 0.25, 12.0))
            shape_delta = float(np.clip((shape_centroid_target - 0.5) * 2.0, -1.0, 1.0))
            shape_mag = float(abs(shape_delta))
            shape_mag_shaped = float(shape_mag ** offpow)
            shape_centroid_target = float(np.clip(0.5 + (0.5 * np.sign(shape_delta) * shape_mag_shaped), 0.0, 1.0))
            if abs(shape_centroid_target - 0.5) < shape_centroid_center_deadzone:
                shape_centroid_target = 0.5
            smooth_alpha = float(np.clip(shape_centroid_smooth_alpha, 0.01, 1.0))
            shape_centroid_x = float(np.clip(prev_shape_centroid_x + (shape_centroid_target - prev_shape_centroid_x) * smooth_alpha, 0.0, 1.0))
        else:
            shape_centroid_x = prev_shape_centroid_x
    
        avg_x_movement = shape_centroid_x - prev_shape_centroid_x
        descriptors = {
            'numpeaks': numpeaks,
            'avg_x_distance': avg_x_distance,
            'avg_x_movement': float(avg_x_movement),
            'x_pos': x_pos,
            'x_distances': x_distances,
            'left_lobe_x': left_lobe_x,
            'right_lobe_x': right_lobe_x,
            'max_lobe_x': max_lobe_x,
            'shape_centroid_x': shape_centroid_x,
        }
        return descriptors
    
    
    def estimate_wave_activity(prev_roi_wave, curr_roi_wave, center_roi_wave, max_amp, prev_activity_value):
        if curr_roi_wave is None or center_roi_wave is None or len(curr_roi_wave) < 8:
            return float(prev_activity_value * 0.9)
    
        curr = curr_roi_wave.astype(np.float32)
        center = center_roi_wave.astype(np.float32)
        if len(center) != len(curr):
            return float(prev_activity_value * 0.9)
    
        residual = curr - center
        abs_residual = np.abs(residual)
    
        motion_mean = 0.0
        motion_peak = 0.0
        if prev_roi_wave is not None and len(prev_roi_wave) == len(curr):
            frame_delta = np.abs(curr - prev_roi_wave.astype(np.float32))
            motion_mean = float(np.mean(frame_delta))
            motion_peak = float(np.percentile(frame_delta, 90))
    
        excursion_mean = float(np.mean(abs_residual))
        excursion_peak = float(np.percentile(abs_residual, 90))
    
        motion_mean_scale = max(1.0, float(max_amp) * 0.020)
        motion_peak_scale = max(1.0, float(max_amp) * 0.045)
        excursion_mean_scale = max(1.0, float(max_amp) * 0.040)
        excursion_peak_scale = max(1.0, float(max_amp) * 0.090)
    
        motion_component = 0.45 * (1.0 - np.exp(-motion_mean / motion_mean_scale))
        motion_component += 0.55 * (1.0 - np.exp(-motion_peak / motion_peak_scale))
    
        excursion_component = 0.40 * (1.0 - np.exp(-excursion_mean / excursion_mean_scale))
        excursion_component += 0.60 * (1.0 - np.exp(-excursion_peak / excursion_peak_scale))
    
        raw_activity = (0.72 * motion_component) + (0.28 * excursion_component)
        raw_activity = float(np.clip(raw_activity, 0.0, 1.0))
        raw_activity = float(raw_activity ** wave_activity_curve_gamma)
        alpha = wave_activity_attack_alpha if raw_activity >= prev_activity_value else wave_activity_release_alpha
        activity = ((1.0 - alpha) * prev_activity_value) + (alpha * raw_activity)
        if activity < 0.01:
            activity = 0.0
        return float(np.clip(activity, 0.0, 1.0))
    
    def estimate_wave_motion(prev_roi_wave, curr_roi_wave, wave_activity, prev_motion_value):
        if curr_roi_wave is None or len(curr_roi_wave) < 8:
            return prev_motion_value * 0.8, prev_roi_wave
    
        curr = curr_roi_wave.astype(np.float32)
        if prev_roi_wave is None or len(prev_roi_wave) != len(curr):
            return prev_motion_value * 0.8, np.copy(curr)
    
        prev = prev_roi_wave.astype(np.float32)
        curr -= np.mean(curr)
        prev -= np.mean(prev)
    
        curr_std = float(np.std(curr))
        prev_std = float(np.std(prev))
        if curr_std < 1e-4 or prev_std < 1e-4:
            return prev_motion_value * 0.8, np.copy(curr_roi_wave.astype(np.float32))
    
        n = len(curr)
        max_lag = int(min(wave_motion_max_lag_px, max(2, n // 6)))
        corr = np.correlate(curr, prev, mode='full').astype(np.float32)
        lags = np.arange(-n + 1, n, dtype=np.int32)
        valid = (lags >= -max_lag) & (lags <= max_lag)
        corr_win = corr[valid]
        lags_win = lags[valid].astype(np.float32)
    
        if len(corr_win) < 3:
            return prev_motion_value * 0.8, np.copy(curr_roi_wave.astype(np.float32))
    
        peak_idx = int(np.argmax(corr_win))
        peak_lag = float(lags_win[peak_idx])
        if 0 < peak_idx < (len(corr_win) - 1):
            y0 = float(corr_win[peak_idx - 1])
            y1 = float(corr_win[peak_idx])
            y2 = float(corr_win[peak_idx + 1])
            denom = (y0 - 2.0 * y1 + y2)
            if abs(denom) > 1e-8:
                peak_lag += 0.5 * (y0 - y2) / denom
    
        peak_val = float(corr_win[peak_idx])
        corr_mean = float(np.mean(corr_win))
        corr_std = float(np.std(corr_win) + 1e-8)
        peak_z = (peak_val - corr_mean) / corr_std
        corr_confidence = float(np.clip((peak_z - 1.0) / 4.0, 0.0, 1.0))
        activity_confidence = float(np.clip(wave_activity / wave_motion_activity_gate, 0.0, 1.0))
        confidence = corr_confidence * activity_confidence
    
        raw_motion = float(np.clip((peak_lag / max(max_lag, 1)) * wave_motion_display_max, -wave_motion_display_max, wave_motion_display_max))
        target_motion = raw_motion * confidence
        motion = ((1.0 - wave_motion_smooth_alpha) * prev_motion_value) + (wave_motion_smooth_alpha * target_motion)
        if abs(motion) < (0.03 * wave_motion_display_max):
            motion = 0.0
        return float(np.clip(motion, -wave_motion_display_max, wave_motion_display_max)), np.copy(curr_roi_wave.astype(np.float32))
    
    
    def classify_rope_shape(roi_wave, center_roi_wave, peak_indices, zero_crossings, x_distances, spectrum_selected, spectrum_cycles, wave_amp, obs_count_roi, max_amp, prev_scores):
        num_states = len(shape_state_labels)
    
        def rising_score(value, low, high):
            if high <= low:
                return 1.0 if value >= high else 0.0
            return float(np.clip((value - low) / (high - low), 0.0, 1.0))
    
        def falling_score(value, low, high):
            return float(1.0 - rising_score(value, low, high))
    
        def target_score(value, center, half_width):
            return float(np.clip(1.0 - (abs(value - center) / max(half_width, 1e-6)), 0.0, 1.0))
    
        if roi_wave is None or center_roi_wave is None or len(roi_wave) < 8:
            scores = np.zeros(num_states, dtype=np.float32)
            scores[-1] = 1.0
            return len(shape_state_labels) - 1, shape_state_labels[-1], 1.0, scores
    
        residual = roi_wave.astype(np.float32) - center_roi_wave.astype(np.float32)
        abs_residual = np.abs(residual)
        peak_count = len(peak_indices)
        zero_cross_count = len(zero_crossings)
    
        if len(x_distances) > 1 and float(np.mean(x_distances)) > 1e-6:
            spacing_cv = float(np.std(x_distances) / (np.mean(x_distances) + 1e-6))
        else:
            spacing_cv = 1.0
    
        if len(spectrum_selected) > 1:
            non_dc = spectrum_selected[1:]
            non_dc_cycles = spectrum_cycles[1:len(spectrum_selected)]
        else:
            non_dc = np.zeros(0, dtype=np.float32)
            non_dc_cycles = np.zeros(0, dtype=np.float32)
    
        non_dc_sum = float(np.sum(non_dc))
        if non_dc_sum > 1e-8:
            dom_idx = int(np.argmax(non_dc))
            dominant_cycle = float(non_dc_cycles[dom_idx])
            dominant_ratio = float(non_dc[dom_idx] / non_dc_sum)
            low_freq_ratio = float(np.sum(non_dc[non_dc_cycles <= 1.25]) / non_dc_sum)
            periodic_ratio = float(np.sum(non_dc[(non_dc_cycles >= 1.5) & (non_dc_cycles <= 5.0)]) / non_dc_sum)
        else:
            dominant_cycle = 0.0
            dominant_ratio = 0.0
            low_freq_ratio = 0.0
            periodic_ratio = 0.0
    
        if len(residual) >= 3:
            curvature_rms_px = float(np.sqrt(np.mean(np.square(np.diff(residual, n=2)))))
        else:
            curvature_rms_px = 0.0
        curvature_norm = float(np.clip(curvature_rms_px / max(float(max_amp) * 0.025, 1.0), 0.0, 1.0))
    
        peak_abs = float(np.max(abs_residual)) if len(abs_residual) > 0 else 0.0
        if peak_abs > 1e-6:
            broad_fraction = float(np.mean(abs_residual > (peak_abs * 0.35)))
        else:
            broad_fraction = 0.0
    
        sign_balance = float(abs(np.mean(residual)) / (np.mean(abs_residual) + 1e-6)) if len(residual) > 0 else 0.0
    
        if obs_count_roi is not None and len(obs_count_roi) == len(roi_wave):
            edge_width = max(4, int(len(obs_count_roi) * 0.12))
            left_edge_coverage = float(np.mean(obs_count_roi[:edge_width] > 0))
            right_edge_coverage = float(np.mean(obs_count_roi[-edge_width:] > 0))
        else:
            left_edge_coverage = 1.0
            right_edge_coverage = 1.0
        one_edge_missing = (left_edge_coverage < 0.20) != (right_edge_coverage < 0.20)
    
        raw_scores = np.zeros(num_states, dtype=np.float32)
    
        raw_scores[0] = (
            0.40 * falling_score(wave_amp, 0.04, 0.11)
            + 0.25 * falling_score(curvature_norm, 0.10, 0.42)
            + 0.20 * falling_score(float(peak_count), 0.5, 2.0)
            + 0.15 * falling_score(float(zero_cross_count), 0.5, 3.0)
        )
    
        raw_scores[1] = (
            0.22 * rising_score(wave_amp, 0.05, 0.20)
            + 0.22 * target_score(float(peak_count), 1.0, 1.0)
            + 0.18 * target_score(dominant_cycle, 1.4, 0.9)
            + 0.18 * target_score(broad_fraction, 0.32, 0.18)
            + 0.10 * falling_score(float(zero_cross_count), 1.5, 4.0)
            + 0.10 * target_score(sign_balance, 0.45, 0.35)
        )
    
        raw_scores[2] = (
            0.22 * rising_score(wave_amp, 0.05, 0.18)
            + 0.22 * rising_score(low_freq_ratio, 0.35, 0.75)
            + 0.18 * rising_score(sign_balance, 0.55, 0.90)
            + 0.18 * rising_score(broad_fraction, 0.45, 0.78)
            + 0.10 * falling_score(float(peak_count), 0.8, 2.5)
            + 0.10 * falling_score(curvature_norm, 0.25, 0.70)
        )
    
        raw_scores[3] = (
            0.22 * rising_score(wave_amp, 0.06, 0.22)
            + 0.20 * rising_score(float(peak_count), 1.5, 4.5)
            + 0.18 * rising_score(float(zero_cross_count), 2.0, 6.0)
            + 0.18 * falling_score(spacing_cv, 0.18, 0.55)
            + 0.12 * rising_score(periodic_ratio, 0.40, 0.78)
            + 0.10 * target_score(dominant_cycle, 2.7, 1.8)
        )
    
        raw_scores[4] = (
            0.30 * (1.0 if one_edge_missing else 0.0)
            + 0.20 * rising_score(wave_amp, 0.08, 0.24)
            + 0.18 * rising_score(curvature_norm, 0.28, 0.78)
            + 0.16 * target_score(broad_fraction, 0.28, 0.20)
            + 0.08 * falling_score(min(left_edge_coverage, right_edge_coverage), 0.15, 0.55)
            + 0.08 * falling_score(sign_balance, 0.55, 0.95)
        )
    
        raw_scores[5] = 0.24
    
        if prev_scores is None or len(prev_scores) != num_states:
            smoothed_scores = raw_scores
        else:
            smoothed_scores = ((1.0 - shape_state_smooth_alpha) * prev_scores) + (shape_state_smooth_alpha * raw_scores)
    
        best_idx = int(np.argmax(smoothed_scores))
        best_score = float(smoothed_scores[best_idx])
        sorted_scores = np.sort(smoothed_scores)
        second_best = float(sorted_scores[-2]) if len(sorted_scores) > 1 else 0.0
        if best_idx != (num_states - 1):
            if best_score < shape_state_min_score or (best_score - second_best) < shape_state_switch_margin:
                best_idx = num_states - 1
                best_score = float(smoothed_scores[best_idx])
    
        return best_idx, shape_state_labels[best_idx], float(np.clip(best_score, 0.0, 1.0)), smoothed_scores.astype(np.float32)
    
    def display_faders(faders, fader_x_positions, mask_center, max_amp, output_img, show_faders, fader_color):
        fader_rect_w = 12
        fader_rect_h = 30
        for i in range(len(faders)):
            y = int(faders[i])
            x = int(fader_x_positions[i])
            y_val = (mask_center[x]-y)/(max_amp*0.5)
            if show_faders:
                cv2.rectangle(output_img, (x - fader_rect_w//2, y - fader_rect_h//2), (x + fader_rect_w//2, y + fader_rect_h//2), fader_color, -1)
                cv2.putText(output_img, f'{y_val:.2f}', (x-20,y+45), cv2.FONT_HERSHEY_SIMPLEX, 0.5, fader_color, 2, cv2.LINE_AA)
    
    
    # ?????? Hex grid helpers ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    _HEX_SQRT3 = np.sqrt(3.0)
    
    def _pixels_to_hex_cells(xs_f, ys_f, ox, oy, size_x, size_y):
        """Vectorized: float pixel arrays ??? set of unique axial (q, r) hex cells (flat-top)."""
        if len(xs_f) == 0:
            return set()
        dx = xs_f - ox;  dy = ys_f - oy
        fq = (2.0 / 3.0) * (dx / size_x)
        fr = (-1.0 / 3.0) * (dx / size_x) + (_HEX_SQRT3 / 3.0) * (dy / size_y)
        fs = -fq - fr
        qi = np.round(fq).astype(np.int32);  ri = np.round(fr).astype(np.int32);  si = np.round(fs).astype(np.int32)
        aq = np.abs(qi.astype(np.float32) - fq)
        ar = np.abs(ri.astype(np.float32) - fr)
        as_ = np.abs(si.astype(np.float32) - fs)
        fix_q = (aq > ar) & (aq > as_)
        fix_r = (~fix_q) & (ar > as_)
        qi = np.where(fix_q, -ri - si, qi)
        ri = np.where(fix_r, -qi - si, ri)
        return set(map(tuple, np.unique(np.column_stack([qi, ri]), axis=0).tolist()))
    
    def _hex_center_px(q, r, ox, oy, size_x, size_y):
        """Flat-top axial (q, r) ??? pixel center (cx, cy)."""
        return ox + size_x * 1.5 * q, oy + size_y * (_HEX_SQRT3 * 0.5 * q + _HEX_SQRT3 * r)
    
    def _hex_verts(cx, cy, size_x, size_y):
        """6 vertices of a flat-top hexagon as int32 ndarray for cv2.polylines."""
        return np.array([[int(cx + size_x * np.cos(np.radians(60.0 * i))),
                          int(cy + size_y * np.sin(np.radians(60.0 * i)))] for i in range(6)], dtype=np.int32)
    
    def draw_hex_grid_overlay(img, active_cells, ox, oy, size_x, size_y, roi_bounds, layout_idx):
        """Draw flat-top hex grid over ROI onto img; highlight active (rope-touched) cells."""
        rl, rr, rt, rb = roi_bounds
        layout_name, dq, dr = HEX_LAYOUTS[layout_idx]
        draw_sx = size_x * 0.90
        draw_sy = size_y * 0.90
        q_min = int(np.floor((2.0 / 3.0) * (rl - ox) / size_x)) - 1
        q_max = int(np.ceil((2.0 / 3.0) * (rr - ox) / size_x)) + 1
        for q in range(q_min, q_max + 1):
            cy_q = oy + size_y * _HEX_SQRT3 * 0.5 * q
            r_min = int(np.floor((rt - cy_q) / (size_y * _HEX_SQRT3))) - 1
            r_max = int(np.ceil((rb - cy_q) / (size_y * _HEX_SQRT3))) + 1
            for r in range(r_min, r_max + 1):
                cx, cy = _hex_center_px(q, r, ox, oy, size_x, size_y)
                if not (rl - size_x < cx < rr + size_x and rt - size_y < cy < rb + size_y):
                    continue
                active = (q, r) in active_cells
                color = hex_grid_active_color if active else hex_grid_dim_color
                cv2.polylines(img, [_hex_verts(cx, cy, draw_sx, draw_sy)], True, color, 2 if active else 1)
                offset = q * dq + r * dr
                cv2.putText(img, str(offset), (int(cx) - 7, int(cy) + 4),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.28, color, 1, cv2.LINE_AA)
        cv2.putText(img, f'hex:{layout_name}', (rl, max(rt - 4, 14)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.52, hex_grid_dim_color, 1, cv2.LINE_AA)
    
    
    def smooth_fill_to_mask_edges(wave_line, centroid_line, left_bound, right_bound, max_y, left_default_y, right_default_y, left_outside_mem_y, right_outside_mem_y):
        filled = np.copy(wave_line)
        if right_bound <= left_bound:
            return filled
    
        valid_all = np.where(centroid_line > 0)[0]
        valid = valid_all[(valid_all >= left_bound) & (valid_all < right_bound)]
        if len(valid) == 0:
            filled[left_bound:right_bound] = np.linspace(left_default_y, right_default_y, right_bound - left_bound)
            filled[:left_bound] = left_default_y
            filled[right_bound:] = right_default_y
            return filled
        if len(valid) == 1:
            idx = int(valid[0])
            y_at_idx = float(filled[idx])
            if idx > left_bound:
                xs = np.arange(left_bound, idx)
                t = (xs - left_bound) / float(idx - left_bound)
                filled[left_bound:idx] = (1.0 - t) * left_default_y + t * y_at_idx
            if idx < (right_bound - 1):
                xs = np.arange(idx + 1, right_bound)
                t = (xs - idx) / float(right_bound - idx)
                filled[idx + 1:right_bound] = (1.0 - t) * y_at_idx + t * right_default_y
            filled[:left_bound] = left_default_y
            filled[right_bound:] = right_default_y
            return filled
    
        left_first = int(valid[0])
        right_last = int(valid[-1])
        total_w = len(filled)
        _extend = 1.5
    
        left_outside = valid_all[valid_all < left_bound]
        right_outside = valid_all[valid_all >= right_bound]
    
        if left_first > left_bound:
            y_at_first = float(filled[left_first])
            gap = left_first - left_bound
            if len(left_outside) > 0:
                anchor_left = int(left_outside[-1])
                y_anchor_left = float(centroid_line[anchor_left])
            else:
                anchor_left = max(0, int(round(left_bound - (_extend * gap))))
                y_anchor_left = float(left_outside_mem_y)
                filled[:anchor_left] = left_default_y
    
            if anchor_left < left_first:
                xs = np.arange(anchor_left, left_first)
                t = (xs - anchor_left) / float(left_first - anchor_left)
                filled[anchor_left:left_first] = (1.0 - t) * y_anchor_left + t * y_at_first
            filled[:anchor_left] = y_anchor_left
        else:
            filled[:left_bound] = filled[left_bound]
    
        if right_last < (right_bound - 1):
            y_at_last = float(filled[right_last])
            gap = (right_bound - 1) - right_last
            if len(right_outside) > 0:
                anchor_right = int(right_outside[0])
                y_anchor_right = float(centroid_line[anchor_right])
            else:
                anchor_right = min(total_w - 1, int(round((right_bound - 1) + (_extend * gap))))
                y_anchor_right = float(right_outside_mem_y)
    
            if right_last < anchor_right:
                xs = np.arange(right_last + 1, anchor_right + 1)
                t = (xs - right_last) / float(anchor_right - right_last)
                filled[right_last + 1:anchor_right + 1] = (1.0 - t) * y_at_last + t * y_anchor_right
            filled[anchor_right + 1:] = y_anchor_right
        else:
            filled[right_bound:] = filled[right_bound - 1]
    
        return filled
    
    try:
        print('Starting video. Press q to exit.')
        display_frame_queue = mp.Queue(maxsize=2)
        display_key_queue = mp.Queue(maxsize=64)
        display_stop_event = mp.Event()
        display_process = mp.Process(
            target=display_worker_process,
            args=(display_frame_queue, display_key_queue, display_stop_event, 'Rope', size),
            daemon=True,
        )
        display_process.start()
        # ?????? Hex grid OSC receive (Csound ??? Python layout selection) ?????????????????????????????????????????????
        _hex_layout_buf = [0]   # 0-based layout index; written by background OSC thread
        _hex_size_x_buf = [float(hex_grid_fields_x)]
        _hex_size_y_buf = [float(hex_grid_fields_y)]
        _hex_peak_mode_buf = [0]
        _peaknotes_mode_buf = [0]
        _shape_cent_floor_buf = [float(shape_centroid_weight_floor_frac)]
        _shape_cent_gamma_buf = [float(shape_centroid_weight_gamma)]
        _shape_cent_offpow_buf = [float(shape_centroid_offcenter_power)]
    
        def _on_hex_layout(address, *args):
            if args:
                _hex_layout_buf[0] = max(0, min(len(HEX_LAYOUTS) - 1, int(float(args[0])) - 1))
    
        def _on_hex_size_x(address, *args):
            if args:
                _hex_size_x_buf[0] = float(np.clip(float(args[0]), 2.0, 30.0))
    
        def _on_hex_size_y(address, *args):
            if args:
                _hex_size_y_buf[0] = float(np.clip(float(args[0]), 2.0, 30.0))
    
        def _on_hex_peak_mode(address, *args):
            if args:
                _hex_peak_mode_buf[0] = 1 if float(args[0]) >= 0.5 else 0
    
        def _on_peaknotes_mode(address, *args):
            if args:
                _peaknotes_mode_buf[0] = 1 if float(args[0]) >= 0.5 else 0

        def _on_shape_cent_floor(address, *args):
            if args:
                _shape_cent_floor_buf[0] = float(np.clip(float(args[0]), 0.0, 1.00))

        def _on_shape_cent_gamma(address, *args):
            if args:
                _shape_cent_gamma_buf[0] = float(np.clip(float(args[0]), 0.25, 12.0))

        def _on_shape_cent_offpow(address, *args):
            if args:
                _shape_cent_offpow_buf[0] = float(np.clip(float(args[0]), 0.25, 12.0))
    
        # Accept both '/addr' and 'addr' OSC styles for robustness across senders.
        osc_io.register_handler('/hex_layout', _on_hex_layout)
        osc_io.register_handler('hex_layout', _on_hex_layout)
        osc_io.register_handler('/hex_size_x', _on_hex_size_x)
        osc_io.register_handler('hex_size_x', _on_hex_size_x)
        osc_io.register_handler('/hex_size_y', _on_hex_size_y)
        osc_io.register_handler('hex_size_y', _on_hex_size_y)
        osc_io.register_handler('/hex_peak_mode', _on_hex_peak_mode)
        osc_io.register_handler('hex_peak_mode', _on_hex_peak_mode)
        osc_io.register_handler('/peaknotes_mode', _on_peaknotes_mode)
        osc_io.register_handler('peaknotes_mode', _on_peaknotes_mode)
        osc_io.register_handler('/shapecent_floor', _on_shape_cent_floor)
        osc_io.register_handler('shapecent_floor', _on_shape_cent_floor)
        osc_io.register_handler('/shapecent_gamma', _on_shape_cent_gamma)
        osc_io.register_handler('shapecent_gamma', _on_shape_cent_gamma)
        osc_io.register_handler('/shapecent_offpow', _on_shape_cent_offpow)
        osc_io.register_handler('shapecent_offpow', _on_shape_cent_offpow)
        osc_io.start_background_receive_server()
        # Ask Csound for current hex settings. If Csound isn't up yet, this is harmless;
        # Csound also pushes values at its own startup and on later changes.
        try:
            osc_io.sendOSC('hex_query', 1)
        except Exception:
            pass
        # Hex grid origin: center of the analysis ROI (fixed for the session)
        hex_orig_x = (mask_left + mask_right) // 2
        hex_orig_y = (roi_top_y + roi_bottom_y) // 2
        hex_layout_idx = 0   # local copy, updated each frame from _hex_layout_buf
        peaknotes_prev_bins = {}  # {(bin_idx, is_positive): vel}
        peaknotes_mode_was_active = False
        frame_num = 0
        underflow_window_start = time.time()
        perf_window_start = underflow_window_start
        while True:
            frame_num += 1
            time_start = time.time()
            if record_writer is not None:
                record_frame = cv2.cvtColor(raw_current_frame, cv2.COLOR_BGR2GRAY)
                record_writer.write(record_frame)
                if (record_started_time is not None) and ((time.time() - record_started_time) >= record_max_seconds):
                    record_writer, record_started_time = stop_recording(record_writer, reason='auto-stopped after 60 seconds')
            current_frame_gray = cv2.cvtColor(current_frame, cv2.COLOR_BGR2GRAY)
            # diff and mask
            # Per-frame diff polarity: choose based on whether rope is darker or lighter than background.
            if rope_is_darker:
                frame_diff_prev = cv2.subtract(previous_frame_gray, current_frame_gray)
            else:
                frame_diff_prev = cv2.subtract(current_frame_gray, previous_frame_gray)
            # Background model: freeze accumulator while paused so toggles compare the same source frame/state.
            if paused:
                bg_frame_uint8 = np.clip(prev_frame_float, 0, 255).astype(np.uint8)
            else:
                bg_frame_uint8, prev_frame_float = lowpass_over_time(current_frame_gray, bg_alpha, prev_frame_float)
            if use_bg_model:
                # Background diff catches rope positions regardless of motion speed.
                if rope_is_darker:
                    frame_diff_bg = cv2.subtract(bg_frame_uint8, current_frame_gray)
                else:
                    frame_diff_bg = cv2.subtract(current_frame_gray, bg_frame_uint8)
                frame_diff = cv2.max(frame_diff_prev, frame_diff_bg)
                # Suppress pixels whose long-term average is persistently dark:
                # those are static dark objects, not rope, and their noise must not fire.
                _, bg_bright_mask = cv2.threshold(bg_frame_uint8, dark_floor, 255, cv2.THRESH_BINARY)
                frame_diff = cv2.bitwise_and(frame_diff, frame_diff, mask=bg_bright_mask)
            else:
                frame_diff = frame_diff_prev
            if use_screen_blend:
                frame_diff = screen_blend_self(frame_diff)
            frame_diff_masked = cv2.bitwise_and(frame_diff, frame_diff, mask=mask)
            frame_diff_masked = cv2.blur(frame_diff_masked, (blur_size,blur_size))
            frame_diff_full = cv2.blur(frame_diff, (blur_size, blur_size))
            # threshold the image to make hard black/white
            _, binary_img_roi = cv2.threshold(frame_diff_masked, binary_thresh, 255, cv2.THRESH_BINARY)
            _, binary_img = cv2.threshold(frame_diff_full, binary_thresh, 255, cv2.THRESH_BINARY)
            time_binary = time.time()
            max_image = np.shape(binary_img_roi)[0]*np.shape(binary_img_roi)[1]*255
            activation_sum = np.sum(binary_img_roi)/max_image
            
            diff_thresh = 0.000001 # can use this to hold last shape (set thresh higher than approx 0.01)
            noise_gate = 1
            #if activation_sum < diff_thresh:
                #binary_img = prev_binary_img
                #noise_gate = 0
            
            # output img for display of curves
            wave_img = np.zeros((dimensions[0], dimensions[1],3), np.uint8)
            time_wave_img_init = time.time()
            # find centroid, disambiguation of rope trace
            centroid_1D_raw, centroid_obs_count = centroid_1D_from_img(binary_img, wave_img, show_centroid, centroid_color)
            if use_kinematic_constraint:
                centroid_1D = constrain_centroid_by_rope_kinematics(centroid_1D_raw, centroid_obs_count, prev_wave_1D, mask_left, mask_right)
            else:
                centroid_1D = centroid_1D_raw
            remembered_left_endpoint_y, remembered_right_endpoint_y = update_endpoint_memory(
                centroid_1D_raw,
                centroid_obs_count,
                remembered_left_endpoint_y,
                remembered_right_endpoint_y,
            )
            remembered_left_outside_y, remembered_right_outside_y = update_outside_anchor_memory(
                centroid_1D_raw,
                centroid_obs_count,
                mask_left,
                mask_right,
                remembered_left_outside_y,
                remembered_right_outside_y,
            )
            # fill in any blanks in the wave
            filter_padding = 0
            #if noise_gate == 0:
            #    wave_1D = prev_wave_1D
            #else:
            #    prev_binary_img = binary_img
            #    wave_1D = np.zeros(dimensions[1]+filter_padding*2)
            wave_1D = np.zeros(dimensions[1])
            wave_1D = fill_in_missing_points(remembered_left_endpoint_y, remembered_right_endpoint_y, centroid_1D, wave_1D, wave_img, False, fill_blanks_color)
            # median filtering
            filter_size1 = 43  # 1.5x original size for stronger smoothing
            wave_1D_filled = np.copy(wave_1D)
            wave_1D_filled = smooth_fill_to_mask_edges(
                wave_1D_filled,
                centroid_1D,
                mask_left,
                mask_right,
                dimensions[0] - 1,
                remembered_left_endpoint_y,
                remembered_right_endpoint_y,
                remembered_left_outside_y,
                remembered_right_outside_y,
            )
            wave_1D_median = median_filter(wave_1D_filled, size=filter_size1)
            # lowpass
            filter_size = 40
            wave_1D_lowpass = lfilter(b, a, wave_1D_median)
            # Use the most-processed active stage for analysis/FFT so filter toggles affect the FFT.
            # Gap-fill is always the minimum (structural, not stylistic).
            wave_1D_final = wave_1D_filled
            if show_medianfilter:
                wave_1D_final = wave_1D_median
            if show_lowpassfilter:
                wave_1D_final = wave_1D_lowpass
            prev_wave_1D = wave_1D
            # final 1D wave used for analysis
            wave_1D = wave_1D_final
            time_filter = time.time()
            # find center and derive activity from the rope trace rather than binary silhouette area
            center_wave = find_center_wave_regr(wave_1D, mask_left, mask_right)
            center_roi_wave = center_wave[mask_left:mask_right]
            roi_wave_for_motion = wave_1D[mask_left:mask_right]
            if len(roi_wave_for_motion) > 0:
                roi_residual = roi_wave_for_motion.astype(np.float32) - center_roi_wave.astype(np.float32)
                wave_amp_rms_px = float(np.sqrt(np.mean(np.square(roi_residual))))
                if len(roi_residual) > 2:
                    _sample_count = int(max(8, curvature_profile_samples))
                    _x_src = np.linspace(0.0, 1.0, len(roi_residual), dtype=np.float32)
                    _x_dst = np.linspace(0.0, 1.0, _sample_count, dtype=np.float32)
                    _residual_ds = np.interp(_x_dst, _x_src, roi_residual).astype(np.float32)
                    _residual_smooth = np.convolve(_residual_ds, np.array([1.0, 4.0, 6.0, 4.0, 1.0], dtype=np.float32) / 16.0, mode='same')
                    _d1 = np.diff(_residual_smooth)
                    _d2 = np.diff(_residual_smooth, n=2)
                    _slope_rms_px = float(np.sqrt(np.mean(np.square(_d1))))
                    _curvature_rms_px = float(np.sqrt(np.mean(np.square(_d2))))
                    _sample_span = float(_sample_count - 1)
                    _slope_norm = _slope_rms_px * _sample_span * np.sqrt(2) / max(max_amp * np.pi, 1.0)
                    _curvature_norm = _curvature_rms_px * (_sample_span ** 2) / max(max_amp * (np.pi ** 2) * np.sqrt(2), 1.0)
                    _turn_norm = ((1.0 - curvature_slope_mix) * _curvature_norm) + (curvature_slope_mix * _slope_norm)
                    _turn_shaped = _turn_norm ** curvature_gamma
                    curvature_rms = float(np.clip(_turn_shaped * curvature_sensitivity, 0.0, 2.0))
                else:
                    curvature_rms = 0.0
            else:
                wave_amp_rms_px = 0.0
                curvature_rms = 0.0
            wave_amp = float(np.clip(wave_amp_rms_px / max((max_amp * 0.25), 1.0), 0.0, 1.0))
            wave_activity = estimate_wave_activity(prev_roi_wave_motion, roi_wave_for_motion, center_roi_wave, max_amp, wave_activity)
            wave_motion_value, prev_roi_wave_motion = estimate_wave_motion(prev_roi_wave_motion, roi_wave_for_motion, wave_activity, wave_motion_value)
            # Find only significant rope lobes using amplitude/prominence on the center-line residual.
            if noise_gate > 0:
                peak_indices, zero_crossings = extract_wave_features(wave_1D, center_wave, mask_left, mask_right, wave_img, show_wavesign, wavesign_color, show_wavecenter, wavecenter_color)
            else:
                peak_indices = []
                zero_crossings = np.zeros(0, dtype=np.float32)
            display_peaks(peak_indices, center_wave, wave_1D, wave_img, show_peaks, peakplus_color, peaknegative_color)
            time_peak_follow = time.time()
    
            # grid faders
            num_faders = 10
            fader_left_x = int(np.clip(mask_left, 0, dimensions[1]-1))
            fader_right_x = int(np.clip(mask_right, 0, dimensions[1]-1))
            fader_x_positions = np.rint(np.linspace(fader_left_x, fader_right_x, num_faders)).astype(np.int32)
            faders = wave_1D[fader_x_positions]
            display_faders(faders, fader_x_positions, mask_center, max_amp, wave_img, show_faders, fader_color)
            # peak parms and stats
            descriptors = compute_peak_descriptors(
                peak_indices,
                wave_1D,
                center_wave,
                mask_center[mask_left:mask_right],
                mask_left,
                mask_right,
                max_amp,
                prev_shape_centroid_x,
                _shape_cent_floor_buf[0],
                _shape_cent_gamma_buf[0],
                _shape_cent_offpow_buf[0],
            )
            prev_shape_centroid_x = descriptors['shape_centroid_x']
            numpeaks = descriptors['numpeaks']
            avg_x_distance = descriptors['avg_x_distance']
            avg_x_movement = descriptors['avg_x_movement']
            x_pos = descriptors['x_pos']
            x_distances = descriptors['x_distances']
    
            peaknotes_mode = _peaknotes_mode_buf[0] > 0
            if peaknotes_mode_was_active and not peaknotes_mode:
                for _key in peaknotes_prev_bins:
                    _bidx, _ispos = _key
                    osc_io.sendOSC('peakbank_off', (_bidx, 1 if _ispos else 0))
                peaknotes_prev_bins = {}
            if peaknotes_mode:
                curr_bins = {}
                roi_width = max(mask_right - mask_left, 1)
                for peak_x in peak_indices:
                    if peak_x < mask_left or peak_x >= mask_right:
                        continue
                    # Quantize normalized x_pos directly to 10 bins.
                    x_pos_norm = (peak_x - mask_left) / roi_width
                    bin_idx = int(np.clip(np.round(x_pos_norm * 9.0), 0, 9))
                    residual = center_wave[peak_x] - wave_1D[peak_x]
                    is_positive = bool(residual > 0)
                    peak_amp = abs(residual) / (max_amp * 0.5)
                    vel = int(np.clip(40 + peak_amp * 80, 40, 127))
                    key = (bin_idx, is_positive)
                    if key not in curr_bins or vel > curr_bins[key]:
                        curr_bins[key] = vel
                for _key in peaknotes_prev_bins:
                    if _key not in curr_bins:
                        _bidx, _ispos = _key
                        osc_io.sendOSC('peakbank_off', (_bidx, 1 if _ispos else 0))
                for _key, _vel in curr_bins.items():
                    if _key not in peaknotes_prev_bins:
                        _bidx, _ispos = _key
                        osc_io.sendOSC('peakbank_on', (_bidx, 1 if _ispos else 0, _vel))
                peaknotes_prev_bins = curr_bins
            peaknotes_mode_was_active = peaknotes_mode
    
            numpeaks_history.append(int(numpeaks))
            numpeaks_median_value = int(round(float(np.median(numpeaks_history))))
            if frame_num == 1:
                numpeaks_lowpass_value = float(numpeaks)
            else:
                numpeaks_lowpass_value += numpeaks_lowpass_alpha * (float(numpeaks) - numpeaks_lowpass_value)
            if numpeaks > max_numpeaks:
                max_numpeaks = numpeaks
            amp_comp = float(np.clip(wave_amp * (max(numpeaks_median_value, 1) / amp_comp_n_ref) ** amp_comp_gamma, 0.0, 2.0))
            # other stats
            if numpeaks > 0:
                for i in range(np.min((len(x_pos),32))):
                    osc_msg = int(i), float(x_pos[i])
                    osc_io.sendOSC('xpos', osc_msg) # send OSC back to client
                for i in range(np.min((len(x_distances),32))):
                    osc_msg = int(i), float(x_distances[i])
                    osc_io.sendOSC('xdistance', osc_msg) # send OSC back to client
            for i in range(np.min((len(zero_crossings),32))):
                osc_msg = i, float(zero_crossings[i])
                osc_io.sendOSC('zerocross', osc_msg) # send OSC back to client
            zc_diff = np.diff(zero_crossings)
            for i in range(np.min((len(zc_diff),32))):
                osc_msg = int(i), float(zc_diff[i])
                osc_io.sendOSC('zerocross_distance', osc_msg) # send OSC back to client
            analysis_wave_1d = wave_1D_lowpass if show_lowpassfilter else wave_1D_median
            roi_wave = analysis_wave_1d[mask_left:mask_right]
            roi_centerline = mask_center[mask_left:mask_right]
            if len(roi_wave) > 0:
                vertical_cog_y = float(np.mean(roi_wave))
                if len(roi_centerline) == len(roi_wave):
                    cog_offset_px = float(np.mean(roi_wave - roi_centerline))
                    vertical_cog_norm = float(np.clip(0.5 + (cog_offset_px / max(float(max_amp), 1.0)), 0.0, 1.0))
                else:
                    vertical_cog_norm = 0.5
            else:
                vertical_cog_y = float(np.mean(roi_centerline))
                vertical_cog_norm = 0.5
            # Finite-interval frequency analysis on observed ROI samples only.
            # This excludes endpoint-filled samples from contributing to the spectral fit.
            freq_analysis_t0 = time.perf_counter()
            roi_wave_full = roi_wave.astype(np.float32)
            roi_obs_mask = centroid_obs_count[mask_left:mask_right] > 0
            sine_selected, sine_input = compute_observed_sine_spectrum(roi_wave_full, roi_obs_mask, sine_display_cycles)

            # Encourage bins that fluctuate with motion (reduce static low-bin shelf bias).
            sine_fluctuation_history.append(np.copy(sine_selected))
            if len(sine_fluctuation_history) >= 3:
                fluct_array = np.stack(sine_fluctuation_history, axis=0)
                sine_fluctuation = np.std(fluct_array, axis=0)
            else:
                sine_fluctuation = np.abs(sine_selected - sine_selected_prev)
            sine_selected_prev = np.copy(sine_selected)
            sine_fluct_norm = sine_fluctuation / max(float(np.max(sine_fluctuation)), 1e-9)

            # Correlate finite-sine bins with numpeaks estimate; tolerate doubling/halving ambiguity.
            numpeaks_cycle_a = max(float(numpeaks_median_value), 0.5)
            numpeaks_cycle_b = max(float(numpeaks_median_value) * 0.5, 0.5)
            numpeaks_sigma = 0.70
            numpeaks_weight = np.maximum(
                np.exp(-0.5 * ((sine_display_cycles - numpeaks_cycle_a) / numpeaks_sigma) ** 2),
                np.exp(-0.5 * ((sine_display_cycles - numpeaks_cycle_b) / numpeaks_sigma) ** 2),
            ).astype(np.float32)
            sine_selected = sine_selected * (0.62 + (0.38 * numpeaks_weight))
            sine_fluct_weight = np.power(sine_fluct_norm, sine_fluct_emphasis_exp)
            sine_selected = sine_selected * (sine_fluct_weight_base + (sine_fluct_weight_gain * sine_fluct_weight))

            # Segment-aware guards: slow segments should not show strong high bins, and fast segments should not show strong very-low bins.
            if numpeaks_cycle_a <= 0.9:
                sine_selected[sine_display_cycles > 2.0] *= 0.22
            elif numpeaks_cycle_a >= 2.5:
                sine_selected[sine_display_cycles < 0.75] *= 0.28

            # Dampen persistent very-low artifacts while keeping truly oscillating low bins.
            very_low_mask = sine_display_cycles < 0.5
            if np.any(very_low_mask):
                sine_selected[very_low_mask] *= (0.45 + (0.55 * sine_fluct_norm[very_low_mask]))

            # Local spectral contrast helps reduce broad static energy across lower bins.
            local_kernel = np.array([0.15, 0.20, 0.30, 0.20, 0.15], dtype=np.float32)
            local_background = np.convolve(sine_selected, local_kernel, mode='same')
            local_peakiness = np.maximum(sine_selected - local_background, 0.0)
            sine_selected = (0.55 * sine_selected) + (0.45 * local_peakiness)

            # Suppress persistent high-frequency artifacts beyond physically plausible rope modes.
            hf_mask = sine_display_cycles > sine_highcut_start_cycles
            if np.any(hf_mask):
                hf_weight = np.exp(-sine_highcut_alpha * (sine_display_cycles[hf_mask] - sine_highcut_start_cycles))
                sine_selected[hf_mask] *= hf_weight.astype(np.float32)

            # Subtract a robust high-frequency floor estimate from all bins.
            hf_floor_mask = sine_display_cycles >= sine_noise_floor_start_cycles
            if np.any(hf_floor_mask):
                hf_floor = float(np.median(sine_selected[hf_floor_mask]))
                sine_selected = np.maximum(sine_selected - (sine_noise_floor_subtract * hf_floor), 0.0)

            sine_selected = sine_selected * sine_amplitude_scale

            highmode_mask = sine_display_cycles > sine_highmode_start_cycles
            if np.any(highmode_mask):
                sine_highmode = float(np.mean(sine_selected[highmode_mask]))
            else:
                sine_highmode = 0.0
            # A fitted single-mode sine with full half-swing has amplitude ~= max_amp/2.
            sine_ref = max(1e-9, max_amp / 2.0)
            # Log (dB) scale for both display and OSC ??? Csound receives what you see.
            sine_db = 20.0 * np.log10(np.maximum(sine_selected / sine_ref, 1e-9))
            sine_display_values = np.clip((sine_db - sine_display_db_floor) / (sine_display_db_ceiling - sine_display_db_floor), 0.0, 1.0)
            sine_display_values = np.power(sine_display_values, sine_display_shape_gamma)
            sine_display_values = np.power(sine_display_values, sine_display_peak_emphasis_exp)
            sine_display_values *= (sine_display_peak_renorm_ref / max(sine_display_peak_renorm_ref ** sine_display_peak_emphasis_exp, 1e-9))
            sine_display_values = np.clip(sine_display_values, 0.0, 1.0)
            highmode_db = 20.0 * float(np.log10(max(sine_highmode / sine_ref, 1e-9)))
            sine_highmode_norm = float(np.clip((highmode_db - sine_display_db_floor) / (sine_display_db_ceiling - sine_display_db_floor), 0.0, 1.0))
            sine_highmode_norm = float(sine_highmode_norm ** sine_display_shape_gamma)
            # Spectral centroid: amplitude-weighted mean cycle frequency using modes <= 10 cycles.
            # Normalized 0-1 (0=DC, 1=10 cycles). Matches what is displayed in the stats panel.
            lf_mask = sine_display_cycles <= 10.0
            lf_cycles = sine_display_cycles[lf_mask]
            lf_magnitudes = sine_selected[lf_mask]
            lf_sum = float(np.sum(lf_magnitudes))
            if lf_sum > 0.0:
                spectral_centroid_cycles = float(np.sum(lf_cycles * lf_magnitudes) / lf_sum)
            else:
                spectral_centroid_cycles = 0.0
            spectral_centroid_norm = float(np.clip(spectral_centroid_cycles / 10.0, 0.0, 1.0))
            freq_analysis_ms = (time.perf_counter() - freq_analysis_t0) * 1000.0
            shape_state_id, shape_state_label, shape_state_confidence, shape_state_scores = classify_rope_shape(
                roi_wave,
                center_roi_wave,
                peak_indices,
                zero_crossings,
                x_distances,
                sine_selected,
                sine_display_cycles,
                wave_amp,
                centroid_obs_count[mask_left:mask_right],
                max_amp,
                shape_state_scores,
            )
            osc_io.sendOSC('shape_state', (float(shape_state_id), float(shape_state_confidence)))
            # Consolidate all peak/shape/activity/centroid metrics into one OSC message.
            osc_msg = (
                float(numpeaks),
                float(numpeaks_median_value),
                float(numpeaks_lowpass_value),
                float(avg_x_distance),
                float(avg_x_movement),
                float(descriptors['left_lobe_x']),
                float(descriptors['right_lobe_x']),
                float(descriptors['max_lobe_x']),
                float(descriptors['shape_centroid_x']),
                float(wave_activity),
                float(wave_amp),
                float(spectral_centroid_norm),
                float(descriptors['shape_centroid_x']),
                float(vertical_cog_norm),
                float(amp_comp),
                float(curvature_rms),
            )
            osc_io.sendOSC('rope_metrics', osc_msg) # send OSC back to client
            for i in range(len(faders)):
                x = int(fader_x_positions[i])
                val = (mask_center[x]-faders[i])/(max_amp*0.5)
                osc_msg = i, val, len(faders)
                osc_io.sendOSC('faders', osc_msg) # send OSC back to client
            time_stats = time.time()
            # ?????? Hex grid cell detection + OSC dispatch ????????????????????????????????????????????????????????????????????????????????????
            hex_layout_idx = _hex_layout_buf[0]
            hex_fields_x = float(np.clip(_hex_size_x_buf[0], 2.0, 30.0))
            hex_fields_y = float(np.clip(_hex_size_y_buf[0], 2.0, 30.0))
            roi_w = max(mask_right - mask_left, 1)
            roi_h = max(roi_bottom_y - roi_top_y, 1)
            # Convert desired field counts to flat-top hex radii (pixels).
            hex_size_x = float(np.clip(roi_w / (1.5 * hex_fields_x + 0.5), 2.0, 1000.0))
            hex_size_y = float(np.clip(roi_h / (((hex_fields_y - 1.0) * _HEX_SQRT3) + 2.0), 2.0, 1000.0))
            _, hex_dq, hex_dr = HEX_LAYOUTS[hex_layout_idx]
            hex_peak_mode = _hex_peak_mode_buf[0] > 0
            if hex_peak_mode:
                xs_h = np.array([x for x in peak_indices if mask_left <= x < mask_right], dtype=np.int32)
            else:
                xs_h = np.arange(mask_left, mask_right, 2, dtype=np.int32)
            ys_h = wave_1D[xs_h].astype(np.int32) if len(xs_h) > 0 else np.zeros(0, dtype=np.int32)
            valid_h = (ys_h >= roi_top_y) & (ys_h <= roi_bottom_y)
            current_hex_cells = _pixels_to_hex_cells(
                xs_h[valid_h].astype(np.float32), ys_h[valid_h].astype(np.float32),
                hex_orig_x, hex_orig_y, hex_size_x, hex_size_y)
            hex_vel = int(np.clip(40 + wave_activity * 87, 40, 127))
            for _q, _r in (current_hex_cells - hex_active_cells):
                _off = _q * hex_dq - _r * hex_dr
                if abs(_off) <= 60:
                    osc_io.sendOSC('hex_note_on', (int(_off), hex_vel))
            for _q, _r in (hex_active_cells - current_hex_cells):
                _off = _q * hex_dq - _r * hex_dr
                if abs(_off) <= 60:
                    osc_io.sendOSC('hex_note_off', int(_off))
            hex_active_cells = current_hex_cells
    
            display_frame_counter += 1
            update_display_this_frame = paused or (display_frame_counter % display_update_stride == 0)
            display_sent_in_worker = False

            if update_display_this_frame and display_compose_in_worker and (display_frame_queue is not None):
                uf_line_color = (140, 140, 255) if underflow_avg_ms_per_sec >= 6.0 else (120, 200, 255) if underflow_avg_ms_per_sec > 0.0 else (210, 210, 210)
                underflow_panel_text = f'underflow {underflow_avg_ms_per_sec:.2f} ms/s   events {underflow_event_rate_per_sec:.2f}/s'
                x_pos_disp = 'x_pos :' + ''.join([f'{x:.2f}, ' for x in x_pos])
                x_dist_disp = 'x_dist :' + ''.join([f'{x:.2f}, ' for x in x_distances])
                zc = ''.join([f'{z:.2f} ' for z in zero_crossings])
                zc_disp = 'zc_dist: ' + ''.join([f'{i:.2f}, ' for i in zc_diff])
                stats_lines = [
                    f'numpeaks raw:{numpeaks} med:{numpeaks_median_value} lp:{numpeaks_lowpass_value:.2f} max:{max_numpeaks}',
                    f'avg_x_dist: {avg_x_distance:.2f}, avg movement {avg_x_movement:.2f}',
                    f'cent tune floor:{_shape_cent_floor_buf[0]:.3f} gamma:{_shape_cent_gamma_buf[0]:.2f} offpow:{_shape_cent_offpow_buf[0]:.2f}',
                    x_pos_disp,
                    x_dist_disp,
                    f'zero_cross: {zc}',
                    zc_disp,
                ]
                wave_activity_text = f'wave activity {wave_activity:.2f}'
                wave_movement_text = f'wave movement {wave_motion_value:+.2f}'
                wave_amp_text = f'wave amp rms {wave_amp:.2f}'
                wave_amp_comp_text = f'amp comp {amp_comp:.2f}'
                wave_curvature_text = f'curvature rms {curvature_rms:.2f}'
                wave_shape_text = f'shape {shape_state_label} ({shape_state_confidence:.2f})'
                (wave_activity_text_w, _), _ = cv2.getTextSize(wave_activity_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_movement_text_w, _), _ = cv2.getTextSize(wave_movement_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_amp_text_w, _), _ = cv2.getTextSize(wave_amp_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_amp_comp_text_w, _), _ = cv2.getTextSize(wave_amp_comp_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_curvature_text_w, _), _ = cv2.getTextSize(wave_curvature_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_shape_text_w, _), _ = cv2.getTextSize(wave_shape_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                stats_panel_label_w = max(wave_activity_text_w, wave_movement_text_w, wave_amp_text_w, wave_amp_comp_text_w, wave_curvature_text_w, wave_shape_text_w)
                option_rows = [
                    ('b', 'binary', show_binary, binary_option_color),
                    ('f', 'filled', show_fill_blanks, filled_option_color),
                    ('m', 'median', show_medianfilter, median_option_color),
                    ('l', 'lowpass', show_lowpassfilter, lowpass_option_color),
                    ('w', 'final', show_finalwave, final_option_color),
                    ('o', 'center', show_wavecenter, center_option_color),
                    ('g', 'bg model', use_bg_model, bg_model_option_color),
                    ('e', 'equalize', use_screen_blend, screen_blend_option_color),
                    ('k', 'kinematic', use_kinematic_constraint, kinematic_option_color),
                    ('d', f'polarity {"dark" if rope_is_darker else "light"}', True, polarity_option_color),
                    ('x', 'reset max peaks', True, option_stats_color),
                    ('1-4', f'display every {display_update_stride}', True, option_stats_color),
                    ('H', f'hex grid ({HEX_LAYOUTS[_hex_layout_buf[0]][0]})', show_hex_grid, hex_grid_active_color),
                    ('z', 'options', show_option_panel, option_stats_color),
                ]
                payload = {
                    'current_frame': current_frame.copy(),
                    'wave_img': wave_img.copy(),
                    'binary_img': binary_img.copy(),
                    'pts': pts.copy(),
                    'wave_1D_filled': wave_1D_filled.copy(),
                    'wave_1D_median': wave_1D_median.copy(),
                    'wave_1D_lowpass': wave_1D_lowpass.copy(),
                    'wave_1D_final': wave_1D_final.copy(),
                    'mask_left': mask_left,
                    'mask_right': mask_right,
                    'roi_top_y': roi_top_y,
                    'roi_bottom_y': roi_bottom_y,
                    'descriptors': dict(descriptors),
                    'vertical_cog_y': vertical_cog_y,
                    'vertical_cog_norm': vertical_cog_norm,
                    'hex_active_cells': list(hex_active_cells),
                    'hex_orig_x': hex_orig_x,
                    'hex_orig_y': hex_orig_y,
                    'hex_size_x': hex_size_x,
                    'hex_size_y': hex_size_y,
                    'hex_layout_idx': hex_layout_idx,
                    'show_binary': show_binary,
                    'show_mask': show_mask,
                    'show_fill_blanks': show_fill_blanks,
                    'show_medianfilter': show_medianfilter,
                    'show_lowpassfilter': show_lowpassfilter,
                    'show_finalwave': show_finalwave,
                    'show_hex_grid': show_hex_grid,
                    'show_option_panel': show_option_panel,
                    'show_sine_spectrum': show_sine_spectrum,
                    'show_stats': show_stats,
                    'stats_lines': stats_lines,
                    'wave_texts': {
                        'activity': wave_activity_text,
                        'movement': wave_movement_text,
                        'amp': wave_amp_text,
                        'amp_comp': wave_amp_comp_text,
                        'curvature': wave_curvature_text,
                        'shape': wave_shape_text,
                    },
                    'stats_panel_label_w': stats_panel_label_w,
                    'option_rows': option_rows,
                    'sine_display_values': np.array(sine_display_values, copy=True),
                    'sine_display_cycles': np.array(sine_display_cycles, copy=True),
                    'sine_display_height': sine_display_height,
                    'spectral_centroid_cycles': spectral_centroid_cycles,
                    'sine_highmode_norm': sine_highmode_norm,
                    'max_amp': max_amp,
                    'wave_activity': wave_activity,
                    'wave_motion_value': wave_motion_value,
                    'wave_motion_slider_max': wave_motion_slider_max,
                    'wave_amp': wave_amp,
                    'amp_comp': amp_comp,
                    'curvature_rms': curvature_rms,
                    'shape_state_label': shape_state_label,
                    'total_skipped': display_skipped_total,
                    'current_skipped': display_skipped_current,
                    'underflow_text': underflow_panel_text,
                    'underflow_color': uf_line_color,
                    'colors': display_colors,
                }
                try:
                    display_frame_queue.put_nowait(payload)
                    display_skipped_current = 0
                except Full:
                    display_skipped_total += 1
                    display_skipped_current += 1
                time_labels = time.time()
                time_output = time_labels
                display_sent_in_worker = True
    
            # Display result (draw in processing order so later stages remain visible on top)
            if update_display_this_frame and (not display_sent_in_worker):
                output = cv2.add(current_frame, wave_img)
                if show_binary:
                    binary_tint = np.zeros_like(output)
                    binary_tint[:, :, 0] = binary_img
                    binary_tint[:, :, 1] = binary_img
                    output = cv2.addWeighted(output, 1.0, binary_tint, 0.28, 0)
                if show_mask:
                    polyg_show = cv2.polylines(output,pts=[pts],isClosed=True, color=(255,0,0),thickness=2)
                if show_fill_blanks:
                    draw_wave_line(output, wave_1D_filled, fill_blanks_color, 4)
                if show_medianfilter:
                    draw_wave_line(output, wave_1D_median, median_color, 3)
                if show_lowpassfilter:
                    draw_wave_line(output, wave_1D_lowpass, lowpass_color, 2)
                if show_finalwave:
                    draw_wave_line(output, wave_1D_final, finalwave_color, 2)
                # ROI guide lines: horizontal COG and vertical shape centroid.
                roi_width_px = max(mask_right - mask_left, 1)
                shape_centroid_x_px = int(np.clip(mask_left + descriptors['shape_centroid_x'] * (roi_width_px - 1), mask_left, mask_right - 1))
                vertical_cog_y_px = int(np.clip(vertical_cog_y, roi_top_y, roi_bottom_y))
                cv2.line(output, (mask_left, vertical_cog_y_px), (mask_right, vertical_cog_y_px), red, 1)
                cv2.line(output, (shape_centroid_x_px, roi_top_y), (shape_centroid_x_px, roi_bottom_y), red, 3)
    
                cog_label_font_scale = 0.825
                if show_hex_grid:
                    draw_hex_grid_overlay(output, hex_active_cells, hex_orig_x, hex_orig_y,
                                          hex_size_x, hex_size_y,
                                          (mask_left, mask_right, roi_top_y, roi_bottom_y),
                                          hex_layout_idx)
                cog_label_thickness = 2
                cog_label_x = int(mask_right + 4)
                cog_label_text_y = int(np.clip(vertical_cog_y_px - 4, 20, dimensions[0] - 30))
                cog_label_value_y = int(np.clip(cog_label_text_y + 28, 32, dimensions[0] - 6))
                cv2.putText(output, 'cog', (cog_label_x, cog_label_text_y), cv2.FONT_HERSHEY_SIMPLEX, cog_label_font_scale, red, cog_label_thickness, cv2.LINE_AA)
                cv2.putText(output, f'{vertical_cog_norm:.2f}', (cog_label_x, cog_label_value_y), cv2.FONT_HERSHEY_SIMPLEX, cog_label_font_scale, red, cog_label_thickness, cv2.LINE_AA)
    
                centroid_label = f'cent {descriptors["shape_centroid_x"]:.2f}'
                centroid_font_scale = 0.825
                centroid_thickness = 2
                (centroid_text_w, _), _ = cv2.getTextSize(centroid_label, cv2.FONT_HERSHEY_SIMPLEX, centroid_font_scale, centroid_thickness)
                centroid_label_x = int(np.clip(shape_centroid_x_px - centroid_text_w // 2, 4, dimensions[1] - centroid_text_w - 4))
                centroid_label_y = max(30, roi_top_y - 8)
                cv2.putText(output, centroid_label, (centroid_label_x, centroid_label_y), cv2.FONT_HERSHEY_SIMPLEX, centroid_font_scale, red, centroid_thickness, cv2.LINE_AA)
    
                # add labels
                v_offset = 24
                legend_x = 15
                legend_y = 15
                x_pos_disp = 'x_pos :' + ''.join([f'{x:.2f}, ' for x in x_pos])
                x_dist_disp = 'x_dist :' + ''.join([f'{x:.2f}, ' for x in x_distances])
                zc = ''.join([f'{z:.2f} ' for z in zero_crossings])
                zc_disp = 'zc_dist: ' + ''.join([f'{i:.2f}, ' for i in zc_diff])
                stats_lines = [
                    f'numpeaks raw:{numpeaks} med:{numpeaks_median_value} lp:{numpeaks_lowpass_value:.2f} max:{max_numpeaks}',
                    f'avg_x_dist: {avg_x_distance:.2f}, avg movement {avg_x_movement:.2f}',
                    f'cent tune floor:{_shape_cent_floor_buf[0]:.3f} gamma:{_shape_cent_gamma_buf[0]:.2f} offpow:{_shape_cent_offpow_buf[0]:.2f}',
                    x_pos_disp,
                    x_dist_disp,
                    f'zero_cross: {zc}',
                    zc_disp,
                ]
                wave_activity_text = f'wave activity {wave_activity:.2f}'
                wave_movement_text = f'wave movement {wave_motion_value:+.2f}'
                wave_amp_text = f'wave amp rms {wave_amp:.2f}'
                wave_amp_comp_text = f'amp comp {amp_comp:.2f}'
                wave_curvature_text = f'curvature rms {curvature_rms:.2f}'
                wave_shape_text = f'shape {shape_state_label} ({shape_state_confidence:.2f})'
                wave_activity_slider_width = 300
                (wave_activity_text_w, _), _ = cv2.getTextSize(wave_activity_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_movement_text_w, _), _ = cv2.getTextSize(wave_movement_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_amp_text_w, _), _ = cv2.getTextSize(wave_amp_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_amp_comp_text_w, _), _ = cv2.getTextSize(wave_amp_comp_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_curvature_text_w, _), _ = cv2.getTextSize(wave_curvature_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                (wave_shape_text_w, _), _ = cv2.getTextSize(wave_shape_text, cv2.FONT_HERSHEY_SIMPLEX, 0.96, 1)
                stats_panel_label_w = max(wave_activity_text_w, wave_movement_text_w, wave_amp_text_w, wave_amp_comp_text_w, wave_curvature_text_w, wave_shape_text_w)
                stats_panel_min_width = 20 + stats_panel_label_w + 14 + wave_activity_slider_width + 20
                if show_stats:
                    stats_step = v_offset * 2
                    stats_first_y = 25
                    total_rows = len(stats_lines) + 6
                    stats_panel_height = int((stats_first_y - 8) + ((total_rows - 1) * stats_step) + 18)
                    stats_panel_width = max(int(dimensions[1]*0.40), stats_panel_min_width)
                    draw_transparent_rect(output, 8, 8, stats_panel_width, stats_panel_height, alpha=0.45)
                option_rows = [
                    ('b', 'binary', show_binary, binary_option_color),
                    ('f', 'filled', show_fill_blanks, filled_option_color),
                    ('m', 'median', show_medianfilter, median_option_color),
                    ('l', 'lowpass', show_lowpassfilter, lowpass_option_color),
                    ('w', 'final', show_finalwave, final_option_color),
                    ('o', 'center', show_wavecenter, center_option_color),
                    ('g', 'bg model', use_bg_model, bg_model_option_color),
                    ('e', 'equalize', use_screen_blend, screen_blend_option_color),
                    ('k', 'kinematic', use_kinematic_constraint, kinematic_option_color),
                    ('d', f'polarity {"dark" if rope_is_darker else "light"}', True, polarity_option_color),
                    ('x', 'reset max peaks', True, option_stats_color),
                    ('1-4', f'display every {display_update_stride}', True, option_stats_color),
                    ('H', f'hex grid ({HEX_LAYOUTS[_hex_layout_buf[0]][0]})', show_hex_grid, hex_grid_active_color),
                    ('z', 'options', show_option_panel, option_stats_color),
                ]
                option_box_width = 380
                option_box_height = 12 + len(option_rows)*v_offset
                option_box_x = dimensions[1] - option_box_width - 10
                option_box_y = 8
                if show_option_panel:
                    draw_transparent_rect(output, option_box_x, option_box_y, option_box_width, option_box_height, alpha=0.45)
                    legend_x = option_box_x + 10
                    legend_y = option_box_y + 15
                    for key_symbol, label, enabled, stage_color in option_rows:
                        color = stage_color if enabled else toggle_gray
                        cv2.circle(output, (legend_x, legend_y), 4, color, 4)
                        cv2.putText(output, f'[{key_symbol}] {label}', (legend_x+12,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.96, color, 1, cv2.LINE_AA)
                        legend_y += v_offset
                if show_sine_spectrum:
                    sine_start_x = 16
                    sine_step_x = 34
                    sine_hm_x = sine_start_x + len(sine_display_values) * sine_step_x + 24
                    sine_label_pad = 26
                    sine_plot_height = sine_display_height + sine_label_pad
                    sine_panel_y = dimensions[0] - sine_plot_height - 56
                    sine_base_y = sine_panel_y + sine_plot_height - 1
                    sine_panel_width = (sine_hm_x - 8) + 40
                    draw_transparent_rect(output, 8, sine_panel_y, sine_panel_width, sine_plot_height, alpha=0.35)
                    sine_label_indices = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25}
                    sine_x_positions = sine_start_x + np.arange(len(sine_display_values)) * sine_step_x
                    sine_bar_half_w = max(2, int(0.44 * sine_step_x))
                    for i, sine_val in enumerate(sine_display_values):
                        cycle = sine_display_cycles[i]
                        if cycle < 3.0:
                            sine_color = orange
                        else:
                            sine_color = green
                        bar_height = max(1, int(sine_val * sine_plot_height))
                        x = int(sine_x_positions[i])
                        cv2.rectangle(output, (x - sine_bar_half_w, sine_base_y), (x + sine_bar_half_w, sine_base_y - bar_height), sine_color, -1)
                        if i in sine_label_indices:
                            cv2.putText(output, f'{cycle:g}', (x - 8, sine_base_y + 21), cv2.FONT_HERSHEY_SIMPLEX, 0.7, sine_color, 1, cv2.LINE_AA)

                    spectral_centroid_cycle_clip = float(np.clip(spectral_centroid_cycles, float(sine_display_cycles[0]), float(sine_display_cycles[-1])))
                    spectral_centroid_x = int(np.interp(spectral_centroid_cycle_clip, sine_display_cycles, sine_x_positions))
                    cv2.line(output, (spectral_centroid_x, sine_base_y), (spectral_centroid_x, sine_base_y - sine_plot_height), red, 2)
                    cv2.putText(output, 'cent', (spectral_centroid_x - 14, sine_base_y - sine_plot_height - 6), cv2.FONT_HERSHEY_SIMPLEX, 0.55, red, 1, cv2.LINE_AA)

                    hf_height = max(1, int(sine_highmode_norm * sine_plot_height))
                    cv2.line(output, (sine_hm_x, sine_base_y), (sine_hm_x, sine_base_y - hf_height), red, 3)
                    cv2.putText(output, 'HM', (sine_hm_x - 16, sine_base_y + 22), cv2.FONT_HERSHEY_SIMPLEX, 1.05, red, 1, cv2.LINE_AA)
                if show_stats:
                    stats_x = 20
                    stats_y = 25
                    cv2.putText(output, wave_activity_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, stats_color, 1, cv2.LINE_AA)
                    slider_x = stats_x + stats_panel_label_w + 14
                    slider_h = 14
                    slider_y = stats_y - 13
                    wave_activity_norm = float(np.clip(wave_activity, 0.0, 1.0))
                    slider_fill_w = int(round(wave_activity_norm * wave_activity_slider_width))
                    cv2.rectangle(output, (slider_x, slider_y), (slider_x + wave_activity_slider_width, slider_y + slider_h), stats_color, 1)
                    if slider_fill_w > 0:
                        cv2.rectangle(output, (slider_x, slider_y), (slider_x + slider_fill_w, slider_y + slider_h), stats_color, -1)
                    stats_y += v_offset*2
    
                    if wave_motion_value < 0.0:
                        move_color = green
                    elif wave_motion_value > 0.0:
                        move_color = red
                    else:
                        move_color = stats_color
                    cv2.putText(output, wave_movement_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, move_color, 1, cv2.LINE_AA)
                    move_slider_y = stats_y - 13
                    move_center_x = slider_x + (wave_activity_slider_width // 2)
                    move_norm = float(np.clip(wave_motion_value / wave_motion_slider_max, -1.0, 1.0))
                    move_fill_half = int(round(abs(move_norm) * (wave_activity_slider_width // 2)))
                    cv2.rectangle(output, (slider_x, move_slider_y), (slider_x + wave_activity_slider_width, move_slider_y + slider_h), stats_color, 1)
                    cv2.line(output, (move_center_x, move_slider_y), (move_center_x, move_slider_y + slider_h), stats_color, 1)
                    if move_fill_half > 0:
                        if move_norm >= 0.0:
                            cv2.rectangle(output, (move_center_x, move_slider_y), (move_center_x + move_fill_half, move_slider_y + slider_h), move_color, -1)
                        else:
                            cv2.rectangle(output, (move_center_x - move_fill_half, move_slider_y), (move_center_x, move_slider_y + slider_h), move_color, -1)
                    stats_y += v_offset*2
    
                    cv2.putText(output, wave_amp_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, stats_color, 1, cv2.LINE_AA)
                    amp_slider_y = stats_y - 13
                    wave_amp_norm = float(np.clip(wave_amp, 0.0, 1.0))
                    amp_fill_w = int(round(wave_amp_norm * wave_activity_slider_width))
                    cv2.rectangle(output, (slider_x, amp_slider_y), (slider_x + wave_activity_slider_width, amp_slider_y + slider_h), stats_color, 1)
                    if amp_fill_w > 0:
                        cv2.rectangle(output, (slider_x, amp_slider_y), (slider_x + amp_fill_w, amp_slider_y + slider_h), stats_color, -1)
                    stats_y += v_offset*2
    
                    cv2.putText(output, wave_amp_comp_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, stats_color, 1, cv2.LINE_AA)
                    amp_comp_slider_y = stats_y - 13
                    amp_comp_norm = float(np.clip(amp_comp / 2.0, 0.0, 1.0))
                    amp_comp_fill_w = int(round(amp_comp_norm * wave_activity_slider_width))
                    cv2.rectangle(output, (slider_x, amp_comp_slider_y), (slider_x + wave_activity_slider_width, amp_comp_slider_y + slider_h), stats_color, 1)
                    if amp_comp_fill_w > 0:
                        cv2.rectangle(output, (slider_x, amp_comp_slider_y), (slider_x + amp_comp_fill_w, amp_comp_slider_y + slider_h), stats_color, -1)
                    stats_y += v_offset*2
    
                    cv2.putText(output, wave_curvature_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, stats_color, 1, cv2.LINE_AA)
                    curvature_slider_y = stats_y - 13
                    curvature_norm = float(np.clip(curvature_rms / 2.0, 0.0, 1.0))
                    curvature_fill_w = int(round(curvature_norm * wave_activity_slider_width))
                    cv2.rectangle(output, (slider_x, curvature_slider_y), (slider_x + wave_activity_slider_width, curvature_slider_y + slider_h), stats_color, 1)
                    if curvature_fill_w > 0:
                        cv2.rectangle(output, (slider_x, curvature_slider_y), (slider_x + curvature_fill_w, curvature_slider_y + slider_h), stats_color, -1)
                    stats_y += v_offset*2
    
                    if shape_state_label == 'periodic':
                        shape_color = green
                    elif shape_state_label == 'endpoint-lost':
                        shape_color = red
                    elif shape_state_label == 'arc':
                        shape_color = orange
                    elif shape_state_label == 'straight':
                        shape_color = light_blue
                    elif shape_state_label == 'one-bump':
                        shape_color = yellow
                    else:
                        shape_color = stats_color
                    cv2.putText(output, wave_shape_text, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, shape_color, 1, cv2.LINE_AA)
                    stats_y += v_offset*2
    
                    for line in stats_lines:
                        cv2.putText(output, line, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.96, stats_color, 1, cv2.LINE_AA)
                        stats_y += v_offset*2
    
                uf_line_color = (140, 140, 255) if underflow_avg_ms_per_sec >= 6.0 else (120, 200, 255) if underflow_avg_ms_per_sec > 0.0 else (210, 210, 210)
                underflow_panel_text = f'underflow {underflow_avg_ms_per_sec:.2f} ms/s   events {underflow_event_rate_per_sec:.2f}/s'
                time_labels = time.time()
                if display_frame_queue is not None:
                    payload = (output, display_skipped_total, display_skipped_current, underflow_panel_text, uf_line_color)
                    try:
                        display_frame_queue.put_nowait(payload)
                        display_skipped_current = 0
                    except Full:
                        display_skipped_total += 1
                        display_skipped_current += 1
                time_output = time.time()
            elif not display_sent_in_worker:
                time_labels = time_stats
                time_output = time_stats
    
            # timing, frame rate
            time_now = time.time()
            processing_time = (time_now - time_start)*1000
            
            frame_time = 1000/fps
            raw_wait_time = frame_time - processing_time
            wait_time = int(raw_wait_time)
    
            perf_frame_count += 1
            perf_proc_ms_total += processing_time
            perf_freq_frame_count += 1
            perf_freq_proc_ms_total += freq_analysis_ms
            if update_display_this_frame:
                perf_display_frame_count += 1
                perf_display_proc_ms_total += processing_time
            else:
                perf_skip_frame_count += 1
                perf_skip_proc_ms_total += processing_time
            
            # profiling
            # make array of all times, subtract time_start
            #times = np.array([time_start, time_binary, time_wave_img_init, time_filter, time_peak_follow, time_stats, time_labels, time_output, time_now])
            #times -= time_start
            #print('time_start, time_binary, time_wave_img_init, time_filter, time_peak_follow, time_stats, time_labels, time_output, time_now')
            #with np.printoptions(precision=4, suppress=True):
            #    print(f'times \n {times} \n {np.diff(times)}')
            #    print('total time', time_now - time_start)
    
            if raw_wait_time < 0.0:
                underflow_event_count += 1
                underflow_deficit_ms_total += -raw_wait_time
    
            elapsed_uf = time_now - underflow_window_start
            if elapsed_uf >= 5.0:
                underflow_avg_ms_per_sec = underflow_deficit_ms_total / elapsed_uf
                underflow_event_rate_per_sec = underflow_event_count / elapsed_uf
                underflow_event_count = 0
                underflow_deficit_ms_total = 0.0
                underflow_window_start = time_now
    
            elapsed_perf = time_now - perf_window_start
            if elapsed_perf >= 5.0 and perf_frame_count > 0:
                avg_proc_all = perf_proc_ms_total / perf_frame_count
                avg_proc_disp = (perf_display_proc_ms_total / perf_display_frame_count) if perf_display_frame_count > 0 else 0.0
                avg_proc_skip = (perf_skip_proc_ms_total / perf_skip_frame_count) if perf_skip_frame_count > 0 else 0.0
                avg_freq_ms = (perf_freq_proc_ms_total / perf_freq_frame_count) if perf_freq_frame_count > 0 else 0.0
                freq_share_pct = (100.0 * avg_freq_ms / max(avg_proc_all, 1e-9))
                freq_equiv_ms_per_sec = avg_freq_ms * fps
                freq_underflow_est_ms_per_sec = underflow_avg_ms_per_sec * min(freq_share_pct / 100.0, 1.0)
                print(
                    f'perf {elapsed_perf:.1f}s | stride {display_update_stride} | avg proc {avg_proc_all:.2f}ms '
                    f'| disp {avg_proc_disp:.2f}ms ({perf_display_frame_count}) '
                    f'| skip {avg_proc_skip:.2f}ms ({perf_skip_frame_count}) '
                    f'| freq {avg_freq_ms:.2f}ms ({freq_share_pct:.1f}% proc) '
                    f'| uf {underflow_avg_ms_per_sec:.2f}ms/s '
                    f'| freq->uf est {freq_underflow_est_ms_per_sec:.2f}ms/s '
                    f'| freq eqv {freq_equiv_ms_per_sec:.2f}ms/s'
                )
                perf_frame_count = 0
                perf_display_frame_count = 0
                perf_skip_frame_count = 0
                perf_proc_ms_total = 0.0
                perf_display_proc_ms_total = 0.0
                perf_skip_proc_ms_total = 0.0
                perf_freq_frame_count = 0
                perf_freq_proc_ms_total = 0.0
                perf_window_start = time_now
    
            if wait_time < 1:
                wait_time = 1
    
            key = -1
            if display_key_queue is not None:
                while True:
                    try:
                        key = display_key_queue.get_nowait()
                    except Empty:
                        break
    
            if key == -1:
                time.sleep((0.01 if paused else (wait_time / 1000.0)))
    
            step_one_frame = False
    
            if key == ord('q'):
                break
            if key == ord('p'):
                paused = not paused
                print(f"Paused: {paused}. Press 's' to step one frame while paused.")
            if key == ord('b'):
                show_binary = not show_binary
            if key == ord('f'):
                show_fill_blanks = not show_fill_blanks
            if key == ord('m'):
                show_medianfilter = not show_medianfilter
            if key == ord('l'):
                show_lowpassfilter = not show_lowpassfilter
            if key == ord('w'):
                show_finalwave = not show_finalwave
            if key == ord('o'):
                show_wavecenter = not show_wavecenter
            if key == ord('g'):
                use_bg_model = not use_bg_model
            if key == ord('e'):
                use_screen_blend = not use_screen_blend
            if key == ord('k'):
                use_kinematic_constraint = not use_kinematic_constraint
            if key == ord('d'):
                rope_is_darker = not rope_is_darker
            if key == ord('x'):
                max_numpeaks = 0
                print('Reset max numpeaks.')
            if key in (ord('1'), ord('2'), ord('3'), ord('4')):
                display_update_stride = int(chr(key))
                display_frame_counter = 0
                print(f'Display updates every {display_update_stride} frame(s).')
            if key == ord('z'):
                show_option_panel = not show_option_panel
            if key == ord('s') and paused:
                step_one_frame = True
            if key == ord('H'):
                show_hex_grid = not show_hex_grid
                if not show_hex_grid:
                    _, hdq, hdr = HEX_LAYOUTS[_hex_layout_buf[0]]
                    for _q, _r in list(hex_active_cells):
                        _off = _q * hdq - _r * hdr
                        if abs(_off) <= 60:
                            osc_io.sendOSC('hex_note_off', int(_off))
                    hex_active_cells = set()
            if key == ord('r'):
                if args.use_recorded_video:
                    print('Recording is disabled in recorded-video playback mode.')
                elif record_writer is not None:
                    print('Recording already in progress. Press t to stop.')
                elif test_video_path.exists() and (not record_overwrite_armed):
                    record_overwrite_armed = True
                    print(f'{test_video_path.name} already exists. Press r again to overwrite and start recording.')
                else:
                    if record_overwrite_armed and test_video_path.exists():
                        test_video_path.unlink()
                        print(f'Overwriting existing {test_video_path.name}.')
                    record_writer, record_started_time = start_recording(raw_current_frame)
                    record_overwrite_armed = False
            if key == ord('t'):
                if record_writer is None:
                    print('No active recording to stop.')
                else:
                    record_writer, record_started_time = stop_recording(record_writer)
            if key == ord('c'):
                if args.use_recorded_video:
                    print('Skipping ATEM motion calibration in recorded-video mode.')
                    continue
                print('Running ATEM motion calibration... keep rope moving.')
                if record_writer is not None:
                    record_writer, record_started_time = stop_recording(record_writer, reason='stopped before calibration')
                cap.release()
                run_atem_calibration(mode='motion')
                cap = cv2.VideoCapture(video_device)
                ret, raw_current_frame = read_source_frame(cap, loop_video=False)
                if not ret:
                    break
                current_frame = prepare_frame(raw_current_frame)
                previous_frame_gray = cv2.cvtColor(current_frame, cv2.COLOR_BGR2GRAY)
                prev_frame_float = previous_frame_gray.astype(np.float32)
    
            if paused and (not step_one_frame):
                continue
    
            previous_frame_gray = current_frame_gray.copy()
            ret, raw_current_frame = read_source_frame(cap, loop_video=args.use_recorded_video)
            if not ret:
                break
            current_frame = prepare_frame(raw_current_frame)
    
    except KeyboardInterrupt:
        #cap.release()
        pass
    finally:
        if record_writer is not None:
            record_writer.release()
        if display_stop_event is not None:
            display_stop_event.set()
        if display_frame_queue is not None:
            try:
                display_frame_queue.put_nowait(None)
            except Exception:
                pass
        if display_process is not None:
            display_process.join(timeout=1.0)
            if display_process.is_alive():
                display_process.terminate()
        cap.release()
    print('Done.')
    

if __name__ == '__main__':
    mp.freeze_support()
    main()

