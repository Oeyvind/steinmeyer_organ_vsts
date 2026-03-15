import cv2
import numpy as np 
from scipy.ndimage import median_filter
from scipy.signal import butter, sosfiltfilt, lfilter
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
normal_cutoff = 20 / nyquist
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
fft_color = orange

show_binary = True
show_centroid = False
show_fill_blanks = True
show_medianfilter = False
show_lowpassfilter = False
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
use_screen_blend = True   # screen-blend equalization before threshold
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

def find_peaks(input_1D, center_wave, left_limit, right_limit, output_img, show_wavesign, wavesign_color, show_wavecenter, wavecenter_color):
    # check center value of wave_1D, let this be zero
    # for segment where wave_1d > 0, find index of max value
    # for segment where wave_1D < 0 find index of min value
    threshold = max_amp*0.02
    arr = input_1D-center_wave
    arr[np.abs(arr) < threshold] = 0
    sign = np.sign(arr)
    for i in range(left_limit,right_limit):
        if show_wavesign:
            y = int((sign[i]*150)+center_wave[i])
            cv2.circle(output_img, (i,y), 2, wavesign_color, 1)# display sign
        if show_wavecenter:
            cv2.circle(output_img, (i,int(center_wave[i])), 1, wavecenter_color, 1)# display wave_center
    sign_indices = []
    signum_old = 0
    for i in range(left_limit,right_limit):
        signum = sign[i]
        if (signum != signum_old) and (signum != 0):
            sign_indices.append(i)
        signum_old = signum
    peak_indices = []
    remove_one_apart = []
    sign_old = 0
    for s in sign_indices:
        if s == sign_old+1:
            remove_one_apart.append(s)
        sign_old = s
    for s in remove_one_apart:
        sign_indices.remove(s)
    for i in range(len(sign_indices)):
        if i < len(sign_indices)-1:
            if sign[sign_indices[i]] > 0:
                peak = np.argmax(input_1D[sign_indices[i]:sign_indices[i+1]-1]-center_wave[i])+sign_indices[i]
            else:
                peak = np.argmin(input_1D[sign_indices[i]:sign_indices[i+1]-1]-center_wave[i])+sign_indices[i]
        else:
            if sign[sign_indices[i]] > 0:
                peak = np.argmax(input_1D[sign_indices[i]:]-center_wave[i])+sign_indices[i]
            else:
                peak = np.argmin(input_1D[sign_indices[i]:]-center_wave[i])+sign_indices[i]
        peak_indices.append(int(peak))
    return peak_indices

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
        filter_size1 = 29
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
        wave_1D_final = wave_1D_lowpass
        prev_wave_1D = wave_1D
        # final 1D wave used for analysis
        wave_1D = wave_1D_final
        time_filter = time.time()
        # amount of activity
        wave_activity = np.sum(binary_img)/(dimensions[0]*dimensions[1]*5)
        # find center              
        center_wave = find_center_wave_regr(wave_1D, mask_left, mask_right)
        # find peaks and peak ids
        if noise_gate > 0:
            peak_indices = find_peaks(wave_1D, center_wave, mask_left, mask_right, wave_img, show_wavesign, wavesign_color, show_wavecenter, wavecenter_color)
        else:
            peak_indices = []
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
        osc_msg = numpeaks, avg_x_distance, float(avg_x_movement)
        osc_io.sendOSC('peaks_stats', osc_msg) # send OSC back to client
        osc_msg = descriptors['left_lobe_x'], descriptors['right_lobe_x'], descriptors['max_lobe_x'], descriptors['shape_centroid_x']
        osc_io.sendOSC('shape_stats', osc_msg) # send OSC back to client
        # other stats
        if numpeaks > 0:
            for i in range(np.min((len(x_pos),32))):
                osc_msg = i, x_pos[i]
                osc_io.sendOSC('xpos', osc_msg) # send OSC back to client
            for i in range(np.min((len(x_distances),32))):
                osc_msg = i, x_distances[i]
                osc_io.sendOSC('xdistance', osc_msg) # send OSC back to client
        zero_crossings = np.where(np.abs((np.diff(np.sign(wave_1D-center_wave)))) > 0)/(mask_right-mask_left)
        for i in range(np.min((len(zero_crossings[0]),32))):
            osc_msg = i, (zero_crossings[0][i])
            osc_io.sendOSC('zerocross', osc_msg) # send OSC back to client
        zc_diff = np.diff(zero_crossings[0])
        for i in range(np.min((len(zc_diff),32))):
            osc_msg = i, zc_diff[i]
            osc_io.sendOSC('zerocross_distance', osc_msg) # send OSC back to client
        fft = np.fft.rfft(wave_1D) 
        fftr = np.nan_to_num(np.clip(np.abs((20*np.log(np.real(fft)))), 0, 280))
        for i in range(16):
            osc_msg = i, fftr[i]/280
            osc_io.sendOSC('fft_bin', osc_msg) # send OSC back to client
        for i in range(len(faders)):
            val = (mask_center[i]-faders[i])/(max_amp*0.5)
            osc_msg = i, val, len(faders)
            osc_io.sendOSC('faders', osc_msg) # send OSC back to client
        osc_msg = float(wave_activity)
        osc_io.sendOSC('activity', osc_msg) # send OSC back to client
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
        if show_stats:
            draw_transparent_rect(output, 8, 8, int(dimensions[1]*0.40), 280, alpha=0.45)
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
            for i in range(int(len(fftr)/8)):
                if i < 11: fft_color = orange
                elif i < 30: fft_color = green
                else: fft_color = blue
                cv2.circle(output, ((i*16), dimensions[0]-int(fftr[i])), 4, fft_color, 4)
        if show_stats:
            stats_x = 20
            stats_y = 25
            cv2.putText(output, f'numpeaks: {numpeaks}', (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            cv2.putText(output, f'avg_x_dist: {avg_x_distance:.2f}, avg movement {avg_x_movement:.2f}', (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            x_pos_disp = 'x_pos :'
            for x in x_pos:
                x_pos_disp = x_pos_disp + f'{x:.2f}' + ', '
            cv2.putText(output, x_pos_disp, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            x_dist_disp = 'x_dist :'
            for x in x_distances:
                x_dist_disp = x_dist_disp + f'{x:.2f}' + ', '
            cv2.putText(output, x_dist_disp, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            zc = ''
            for z in zero_crossings[0]:
                zc = zc + f'{z:.2f} ' 
            cv2.putText(output, f'zero_cross: {zc}', (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            zc_disp = 'zc_dist: '
            for i in zc_diff:
                zc_disp = zc_disp + f'{i:.2f}' + ', '
            cv2.putText(output, zc_disp, (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
            stats_y += v_offset*2
            cv2.putText(output, f'wave activity {wave_activity:.2f}', (stats_x,stats_y), cv2.FONT_HERSHEY_SIMPLEX, 0.8, stats_color, 1, cv2.LINE_AA)
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
