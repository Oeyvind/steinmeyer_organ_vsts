import cv2
import numpy as np 
from scipy.ndimage import median_filter
from scipy.signal import butter, sosfiltfilt, lfilter, find_peaks as scipy_find_peaks
from scipy.fft import dct as scipy_dct
import osc_io
import time
import json
import argparse
from pathlib import Path

try:
    from atem_auto_calibrate import run_auto_calibration
except Exception:
    run_auto_calibration = None

timethen = time.time()
SCRIPT_DIR = Path(__file__).resolve().parent
test_video_path = SCRIPT_DIR / 'test_video.avi'


# config parms
binary_thresh = 15
blur_size = 5
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
kinematic_snap_to_obs_px = 22
kinematic_edge_anchor_px = 24
peak_min_amplitude_frac = 0.015
peak_min_prominence_frac = 0.035
peak_min_distance_frac = 0.07
dct_display_cycles = np.array([
    0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75,   # orange: 0.25-step below 3
    3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5,      # green: 0.5-step 3–10
    9.0, 9.5, 10.0
], dtype=np.float32)
dct_highmode_start_cycles = 10.0
dct_display_height = 120
dct_display_db_floor = -40.0  # dB floor for display; -40dB = amplitude 1/100 of full swing
dct_display_db_ceiling = 24.0  # positive headroom so strong modes do not saturate too early
dct_boundary_mode = 'adaptive'  # 'adaptive' (auto-blend), 'mirror' (plain even extension), 'edge' (localized edge correction), or 'lifted' (full-span boundary detrend)

# optional ATEM calibration
atem_enable_calibration = True
atem_ip = '172.31.57.153'
atem_camera_input = 1
atem_gain_values = [100, 200, 300, 400, 500, 600]
atem_collect_seconds = 2.0
atem_settle_seconds = 0.8
atem_sample_seconds_static = 1.2
atem_sample_seconds_motion = 1.8


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
print('mask LR', mask_left, mask_right)
send_counter = 0
max_numpeaks = 0
prev_wave_1D = np.zeros(dimensions[1])
prev_binary_img = np.copy(previous_frame_gray)
spectral_centroid_cycles = 0.0
spectral_centroid_norm = 0.0
horizontal_cog_y = float(np.mean(mask_center[mask_left:mask_right]))
horizontal_cog_norm = float(np.clip(horizontal_cog_y / max(dimensions[0] - 1, 1), 0.0, 1.0))
avg_x_distance = 0
avg_x_movement = 0
prev_shape_centroid_x = 0.5
x_pos = np.zeros(0)
x_distances = np.zeros(0)
record_writer = None
record_started_time = None
record_overwrite_armed = False

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
dct_color = orange

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
show_fft = True
show_option_panel = True
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
polarity_option_color = (255,120,120)
dct_boundary_option_color = (160,255,180)

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
    constrained = np.zeros_like(centroid_1D)
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
            constrained[x] = y_obs
            continue
        if not obs_is_strong:
            continue
        y_cons = constrained[x]
        if y_cons <= 0 or abs(y_cons - y_obs) > kinematic_snap_to_obs_px:
            constrained[x] = y_obs
    return constrained

def fill_in_missing_points(y_init_left, y_init_right, input_1D, output_1D, output_img, show_fill_blanks, fill_blanks_color):
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
    # fill any blank spaces at the end of the array with zeros
    line_len = dimensions[1]-x_prev
    line = np.linspace(y_init_right, y_init_right, line_len)
    output_1D[x_prev:dimensions[1]] = np.reshape(line, shape=(line_len,))
    output_1D[dimensions[1]:] = y_init_right
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

def dct_seam_score(signal_1d):
    """Sum of absolute boundary slopes driving DCT-I mirror-seam cusps."""
    if len(signal_1d) < 4:
        return 0.0
    return float(abs(signal_1d[1] - signal_1d[0]) + abs(signal_1d[-1] - signal_1d[-2]))

def build_dct_boundary_baseline(signal_1d):
    if signal_1d is None or len(signal_1d) < 4:
        return np.zeros_like(signal_1d)
    num_points = len(signal_1d)
    edge_len = max(4, min(24, num_points//8))

    signal_f = signal_1d.astype(np.float32)

    # Endpoint-value-preserving correction: enforce smoother mirrored seam by
    # reducing endpoint slopes with a cubic Hermite term that is exactly zero at both ends.
    left_x = np.arange(edge_len, dtype=np.float32)
    right_x = np.arange(num_points - edge_len, num_points, dtype=np.float32)
    left_slope = float(np.polyfit(left_x, signal_f[:edge_len], 1)[0])
    right_slope = float(np.polyfit(right_x, signal_f[-edge_len:], 1)[0])

    x = np.linspace(0.0, 1.0, num_points, dtype=np.float32)
    slope_left_x = left_slope * (num_points - 1)
    slope_right_x = right_slope * (num_points - 1)
    slope_baseline = (
        slope_left_x * (x**3 - 2.0*x**2 + x) +
        slope_right_x * (x**3 - x**2)
    ).astype(np.float32)

    return slope_baseline

def apply_dct_boundary_lifting(signal_1d):
    if signal_1d is None or len(signal_1d) < 4:
        return signal_1d, np.zeros_like(signal_1d)
    baseline = build_dct_boundary_baseline(signal_1d)
    lifted = signal_1d.astype(np.float32) - baseline
    return lifted, baseline

def apply_dct_edge_boundary_lifting(signal_1d):
    if signal_1d is None or len(signal_1d) < 8:
        return signal_1d, np.zeros_like(signal_1d)
    num_points = len(signal_1d)

    def build_left_slope_patch(sig, patch_len):
        patch = np.zeros_like(sig, dtype=np.float32)
        fit_len = max(4, min(16, patch_len))
        x_fit = np.arange(fit_len, dtype=np.float32)
        slope = float(np.polyfit(x_fit, sig[:fit_len], 1)[0])

        t = np.linspace(0.0, 1.0, patch_len, dtype=np.float32)
        m0 = slope * float(patch_len - 1)
        local_patch = m0 * (t**3 - 2.0*t**2 + t)
        patch[:patch_len] = local_patch
        return patch

    patch_len = max(8, min(64, num_points // 4))
    signal_f = signal_1d.astype(np.float32)

    left_patch = build_left_slope_patch(signal_f, patch_len)
    right_patch = build_left_slope_patch(signal_f[::-1], patch_len)[::-1]

    edge_patch = left_patch + right_patch
    lifted = signal_f - edge_patch
    return lifted, edge_patch

def extract_wave_features(input_1D, center_wave, left_limit, right_limit, output_img, show_wavesign, wavesign_color, show_wavecenter, wavecenter_color):
    roi_width = max(right_limit-left_limit, 1)
    residual = input_1D - center_wave
    amplitude_threshold = max_amp * peak_min_amplitude_frac
    prominence_threshold = max_amp * peak_min_prominence_frac
    min_peak_distance = max(4, int(round(roi_width * peak_min_distance_frac)))

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
                cv2.circle(output_img, (x,y),10, peakplus_color, 4)
            else:
                cv2.circle(output_img, (x,y),10, peaknegative_color, 4)
 
def compute_peak_descriptors(peak_indices, wave_1D, center_wave, mask_left, mask_right, max_amp, prev_shape_centroid_x):
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

    shape_slice = np.abs(wave_1D[mask_left:mask_right] - center_wave[mask_left:mask_right])
    if np.sum(shape_slice) > 0:
        shape_x = np.arange(mask_right-mask_left) / roi_width
        shape_centroid_x = float(np.sum(shape_x * shape_slice) / np.sum(shape_slice))
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

def display_faders(faders, num_faders, fader_distance, fader_pad, mask_left, mask_center, max_amp, output_img, show_faders, fader_color):
    for i in range(num_faders):
        y = int(faders[i])
        y_val = (mask_center[i]-y)/(max_amp*0.5)
        x = (i*fader_distance)+mask_left+fader_pad
        if show_faders:
            cv2.circle(output_img, (x,y), 15, fader_color, 8)
            cv2.putText(output_img, f'{y_val:.2f}', (x-20,y+45), cv2.FONT_HERSHEY_SIMPLEX, 0.5, fader_color, 2, cv2.LINE_AA)


def smooth_fill_to_mask_edges(wave_line, centroid_line, left_bound, right_bound, max_y):
    filled = np.copy(wave_line)
    if right_bound <= left_bound:
        return filled

    valid = np.where(centroid_line[left_bound:right_bound] > 0)[0] + left_bound
    if len(valid) < 2:
        return filled

    left_first = int(valid[0])
    right_last = int(valid[-1])
    fit_count = int(min(12, len(valid)))

    if left_first > left_bound:
        left_fit_x = valid[:fit_count]
        left_fit_y = filled[left_fit_x]
        if len(left_fit_x) >= 2:
            left_m, left_c = np.polyfit(left_fit_x, left_fit_y, 1)
            x_ext = np.arange(left_bound, left_first)
            y_ext = (left_m * x_ext) + left_c
            filled[left_bound:left_first] = np.clip(y_ext, 0, max_y)

    if right_last < (right_bound - 1):
        right_fit_x = valid[-fit_count:]
        right_fit_y = filled[right_fit_x]
        if len(right_fit_x) >= 2:
            right_m, right_c = np.polyfit(right_fit_x, right_fit_y, 1)
            x_ext = np.arange(right_last + 1, right_bound)
            y_ext = (right_m * x_ext) + right_c
            filled[right_last + 1:right_bound] = np.clip(y_ext, 0, max_y)

    filled[:left_bound] = filled[left_bound]
    filled[right_bound:] = filled[right_bound - 1]
    return filled

try:
    print('Starting video. Press q to exit.')
    frame_num = 0
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
        # threshold the image to make hard black/white
        _, binary_img = cv2.threshold(frame_diff_masked, binary_thresh, 255, cv2.THRESH_BINARY)
        time_binary = time.time()
        max_image = np.shape(binary_img)[0]*np.shape(binary_img)[1]*255
        activation_sum = np.sum(binary_img)/max_image
        
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
        # fill in any blanks in the wave
        filter_padding = 0
        #if noise_gate == 0:
        #    wave_1D = prev_wave_1D
        #else:
        #    prev_binary_img = binary_img
        #    wave_1D = np.zeros(dimensions[1]+filter_padding*2)
        wave_1D = np.zeros(dimensions[1])
        wave_1D = fill_in_missing_points(wavecenter_y_left, wavecenter_y_right, centroid_1D, wave_1D, wave_img, False, fill_blanks_color)
        # median filtering
        filter_size1 = 43  # 1.5x original size for stronger smoothing
        wave_1D_filled = np.copy(wave_1D)
        wave_1D_filled = smooth_fill_to_mask_edges(
            wave_1D_filled,
            centroid_1D,
            mask_left,
            mask_right,
            dimensions[0] - 1,
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
        # amount of activity
        wave_activity = np.sum(binary_img)/(dimensions[0]*dimensions[1]*5)
        # find center              
        center_wave = find_center_wave_regr(wave_1D, mask_left, mask_right)
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
        faders = np.zeros(num_faders)
        fader_pad = int((dimensions[1]/(num_faders))*0.2)
        fader_distance = int((dimensions[1]-fader_pad*2)/num_faders)
        for i in range(num_faders):
            faders[i] = wave_1D[i*fader_distance+fader_pad]#/max_amp
        display_faders(faders, num_faders, fader_distance, fader_pad, mask_left, mask_center, max_amp, wave_img, show_faders, fader_color)
        # peak parms and stats
        descriptors = compute_peak_descriptors(peak_indices, wave_1D, center_wave, mask_left, mask_right, max_amp, prev_shape_centroid_x)
        prev_shape_centroid_x = descriptors['shape_centroid_x']
        numpeaks = descriptors['numpeaks']
        avg_x_distance = descriptors['avg_x_distance']
        avg_x_movement = descriptors['avg_x_movement']
        x_pos = descriptors['x_pos']
        x_distances = descriptors['x_distances']
        if numpeaks > max_numpeaks:
            max_numpeaks = numpeaks
            print('new max numpeaks', max_numpeaks)
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
        roi_wave = wave_1D[mask_left:mask_right]
        if len(roi_wave) > 0:
            horizontal_cog_y = float(np.mean(roi_wave))
        else:
            horizontal_cog_y = float(np.mean(mask_center[mask_left:mask_right]))
        horizontal_cog_norm = float(np.clip(horizontal_cog_y / max(dimensions[0] - 1, 1), 0.0, 1.0))
        # DCT zero-reference: horizontal baseline at the rope's vertical center of gravity in the ROI.
        dct_input_raw = roi_wave - horizontal_cog_y
        if dct_boundary_mode == 'adaptive':
            lifted_input, lifted_baseline = apply_dct_boundary_lifting(dct_input_raw)
            score_mirror = dct_seam_score(dct_input_raw)
            score_lifted = dct_seam_score(lifted_input)
            dct_adaptive_w = float(np.clip(score_mirror / (score_mirror + score_lifted + 1e-6), 0.0, 1.0))
            dct_input = ((1.0 - dct_adaptive_w) * dct_input_raw + dct_adaptive_w * lifted_input).astype(np.float32)
            dct_boundary_baseline = (dct_adaptive_w * lifted_baseline).astype(np.float32)
        elif dct_boundary_mode == 'edge':
            dct_input, dct_boundary_baseline = apply_dct_edge_boundary_lifting(dct_input_raw)
            dct_adaptive_w = 1.0
        elif dct_boundary_mode == 'lifted':
            dct_input, dct_boundary_baseline = apply_dct_boundary_lifting(dct_input_raw)
            dct_adaptive_w = 1.0
        else:
            dct_input = dct_input_raw
            dct_boundary_baseline = np.zeros_like(dct_input_raw)
            dct_adaptive_w = 0.0
        # For visualization: DCT-I corresponds to an even extension of the interval endpoints.
        # Effective full wave: x[0..N-1] followed by x[N-2..1].
        if len(dct_input) > 2:
            dct_input_full = np.concatenate((dct_input, dct_input[-2:0:-1]))
        else:
            dct_input_full = dct_input
        if len(dct_input) > 1:
            dct_coefficients = np.abs(scipy_dct(dct_input, type=1, norm='ortho'))
        else:
            dct_coefficients = np.zeros(1, dtype=np.float32)
        dct_bin_indices = np.clip(np.round(dct_display_cycles * 2.0).astype(np.int32), 0, len(dct_coefficients) - 1)
        dct_selected = dct_coefficients[dct_bin_indices]
        highmode_start_index = int(np.floor(dct_highmode_start_cycles * 2.0)) + 1
        if highmode_start_index < len(dct_coefficients):
            dct_highmode = float(np.mean(dct_coefficients[highmode_start_index:]))
        else:
            dct_highmode = 0.0
        # With orthonormal DCT-I, a perfectly matched full-amplitude cosine mode has coefficient ~= amplitude.
        dct_ref = max(1e-9, max_amp / 2.0)
        # Log (dB) scale for both display and OSC — Csound receives what you see.
        dct_db = 20.0 * np.log10(np.maximum(dct_selected / dct_ref, 1e-9))
        dct_display_values = np.clip((dct_db - dct_display_db_floor) / (dct_display_db_ceiling - dct_display_db_floor), 0.0, 1.0)
        highmode_db = 20.0 * float(np.log10(max(dct_highmode / dct_ref, 1e-9)))
        dct_highmode_norm = float(np.clip((highmode_db - dct_display_db_floor) / (dct_display_db_ceiling - dct_display_db_floor), 0.0, 1.0))
        for i in range(len(dct_display_values)):
            osc_msg = i, float(dct_display_values[i])
            osc_io.sendOSC('dct_bin', osc_msg) # send OSC back to client
        osc_io.sendOSC('dct_hf', dct_highmode_norm)
        # Spectral centroid: amplitude-weighted mean cycle frequency using modes <= 10 cycles.
        # Normalized 0-1 (0=DC, 1=10 cycles). Matches what is displayed in the stats panel.
        lf_mask = dct_display_cycles <= 10.0
        lf_cycles = dct_display_cycles[lf_mask]
        lf_magnitudes = dct_selected[lf_mask]
        lf_sum = float(np.sum(lf_magnitudes))
        if lf_sum > 0.0:
            spectral_centroid_cycles = float(np.sum(lf_cycles * lf_magnitudes) / lf_sum)
        else:
            spectral_centroid_cycles = 0.0
        spectral_centroid_norm = float(np.clip(spectral_centroid_cycles / 10.0, 0.0, 1.0))
        # Consolidate all peak/shape/activity/centroid metrics into one OSC message.
        osc_msg = (
            float(numpeaks),
            float(avg_x_distance),
            float(avg_x_movement),
            float(descriptors['left_lobe_x']),
            float(descriptors['right_lobe_x']),
            float(descriptors['max_lobe_x']),
            float(descriptors['shape_centroid_x']),
            float(wave_activity),
            float(spectral_centroid_norm),
            float(descriptors['shape_centroid_x']),
            float(horizontal_cog_norm),
        )
        osc_io.sendOSC('rope_metrics', osc_msg) # send OSC back to client
        for i in range(len(faders)):
            val = (mask_center[i]-faders[i])/(max_amp*0.5)
            osc_msg = i, val, len(faders)
            osc_io.sendOSC('faders', osc_msg) # send OSC back to client
        time_stats = time.time()

        # Display result (draw in processing order so later stages remain visible on top)
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
        # add labels
        v_offset = 20
        legend_x = 15
        legend_y = 15
        x_pos_disp = 'x_pos :' + ''.join([f'{x:.2f}, ' for x in x_pos])
        x_dist_disp = 'x_dist :' + ''.join([f'{x:.2f}, ' for x in x_distances])
        zc = ''.join([f'{z:.2f} ' for z in zero_crossings])
        zc_disp = 'zc_dist: ' + ''.join([f'{i:.2f}, ' for i in zc_diff])
        stats_lines = [
            f'numpeaks: {numpeaks}',
            f'avg_x_dist: {avg_x_distance:.2f}, avg movement {avg_x_movement:.2f}',
            x_pos_disp,
            x_dist_disp,
            f'zero_cross: {zc}',
            zc_disp,
            f'wave activity {wave_activity:.2f}',
            f'shape centroid x: {prev_shape_centroid_x:.3f}  (0=left, 1=right)',
            f'spectral centroid: {spectral_centroid_cycles:.2f} cyc  (norm {spectral_centroid_norm:.3f})',
            f'horizontal cog: y={horizontal_cog_y:.1f}px  (norm {horizontal_cog_norm:.3f})',
        ]
        if show_stats:
            stats_step = v_offset * 2
            stats_first_y = 25
            stats_panel_height = int((stats_first_y - 8) + ((len(stats_lines) - 1) * stats_step) + 18)
            draw_transparent_rect(output, 8, 8, int(dimensions[1]*0.40), stats_panel_height, alpha=0.45)
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
            ('n', f'dct bc {dct_boundary_mode}', True, dct_boundary_option_color),
            ('d', f'polarity {"dark" if rope_is_darker else "light"}', True, polarity_option_color),
            ('z', 'options', show_option_panel, option_stats_color),
        ]
        option_box_width = 320
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
                cv2.putText(output, f'[{key_symbol}] {label}', (legend_x+12,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 1, cv2.LINE_AA)
                legend_y += v_offset
        if show_fft:
            dct_start_x = 14
            dct_step_x = 28
            dct_hm_x = dct_start_x + len(dct_display_values) * dct_step_x + 20
            dct_label_pad = 26
            dct_plot_height = dct_display_height + dct_label_pad
            dct_panel_y = dimensions[0] - dct_plot_height - 56
            dct_base_y = dct_panel_y + dct_plot_height - 1
            dct_panel_width = (dct_hm_x - 8) + 36
            dct_signal_panel_y = dct_panel_y - dct_display_height - 10
            dct_signal_panel_width = min(dimensions[1] - 16, (dct_panel_width * 2))
            draw_transparent_rect(output, 8, dct_signal_panel_y, dct_signal_panel_width, dct_display_height, alpha=0.35)
            bc_label = f'DCT input ({dct_boundary_mode}  w={dct_adaptive_w:.2f} + even ext.)' if dct_boundary_mode == 'adaptive' else f'DCT input ({dct_boundary_mode} + even extension)'
            cv2.putText(output, bc_label, (16, dct_signal_panel_y + 18), cv2.FONT_HERSHEY_SIMPLEX, 0.6, yellow, 1, cv2.LINE_AA)
            draw_centered_signal_panel(output, dct_input_full, 12, dct_signal_panel_y + 24, dct_signal_panel_width - 10, dct_display_height - 30, dull_green, light_blue)
            draw_transparent_rect(output, 8, dct_panel_y, dct_panel_width, dct_plot_height, alpha=0.35)
            dct_label_indices = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25}  # 0.5,1,1.5,2,2.5,3,4,5,6,7,8,9,10
            for i, dct_val in enumerate(dct_display_values):
                cycle = dct_display_cycles[i]
                if cycle < 3.0:
                    dct_color = orange
                else:
                    dct_color = green
                bar_height = max(1, int(dct_val * dct_plot_height))
                x = dct_start_x + i * dct_step_x
                cv2.line(output, (x, dct_base_y), (x, dct_base_y - bar_height), dct_color, 2)
                if i in dct_label_indices:
                    cv2.putText(output, f'{cycle:g}', (x - 8, dct_base_y + 21), cv2.FONT_HERSHEY_SIMPLEX, 0.7, dct_color, 1, cv2.LINE_AA)
            hf_height = max(1, int(dct_highmode_norm * dct_plot_height))
            cv2.line(output, (dct_hm_x, dct_base_y), (dct_hm_x, dct_base_y - hf_height), red, 3)
            cv2.putText(output, 'HM', (dct_hm_x - 16, dct_base_y + 22), cv2.FONT_HERSHEY_SIMPLEX, 1.05, red, 1, cv2.LINE_AA)
        if show_stats:
            stats_x = 20
            stats_y = 25
            for line in stats_lines:
                cv2.putText(output, line, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
                stats_y += v_offset*2
        time_labels = time.time()
        output = cv2.resize(output, size)
        cv2.imshow("Rope", output)
        time_output = time.time()

        # timing, frame rate
        time_now = time.time()
        processing_time = (time_now - time_start)*1000
        
        frame_time = 1000/fps
        wait_time = int(frame_time - processing_time)
        
        # profiling
        # make array of all times, subtract time_start
        #times = np.array([time_start, time_binary, time_wave_img_init, time_filter, time_peak_follow, time_stats, time_labels, time_output, time_now])
        #times -= time_start
        #print('time_start, time_binary, time_wave_img_init, time_filter, time_peak_follow, time_stats, time_labels, time_output, time_now')
        #with np.printoptions(precision=4, suppress=True):
        #    print(f'times \n {times} \n {np.diff(times)}')
        #    print('total time', time_now - time_start)

        if wait_time < 1: 
            print(f'wait time underflow {wait_time}')
            wait_time = 1
        key = cv2.waitKey(0 if paused else wait_time)
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
        if key == ord('n'):
            cycle_modes = ['adaptive', 'mirror', 'edge', 'lifted']
            dct_boundary_mode = cycle_modes[(cycle_modes.index(dct_boundary_mode) + 1) % len(cycle_modes)]
            print(f'DCT boundary mode: {dct_boundary_mode}')
        if key == ord('d'):
            rope_is_darker = not rope_is_darker
        if key == ord('z'):
            show_option_panel = not show_option_panel
        if key == ord('s') and paused:
            step_one_frame = True
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
    cv2.destroyAllWindows()
finally:
    if record_writer is not None:
        record_writer.release()
    cap.release()
print('Done.')
