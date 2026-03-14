import cv2
import numpy as np 
from scipy.ndimage import median_filter
from scipy.signal import butter, sosfiltfilt, lfilter
import osc_io
import time
timethen = time.time()


# config parms
binary_thresh = 15
blur_size = 5
fps = 20
flip = False
mask_up_left  = (0.05, 0.05)
mask_up_right = (0.95, 0.05)
mask_lo_right = (0.95, 0.95)
mask_lo_left  = (0.05, 0.95)
displaysize = 1000

cap = cv2.VideoCapture(1)
ret, current_frame = cap.read()
previous_frame_gray = cv2.cvtColor(current_frame, cv2.COLOR_BGR2GRAY) 
dimensions = current_frame.shape
print(dimensions)

# output size
scale = displaysize/np.shape(current_frame)[1] # data array shape is y,x
size = (displaysize,int(np.shape(current_frame)[0]*scale))

# flip
if flip:
    current_frame = cv2.flip(current_frame,-1)

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
show_fill_blanks = False#False
show_lowpassfilter = True
show_wavecenter = True
show_wavesign = False
show_mask = True
show_peaks = True
show_stats = True
show_faders = True
show_fft = True

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
    for i in range(dimensions[1]):
        y_coords = np.nonzero(input_img[:,i])
        if len(y_coords[0]) > 0:
            y_centroid = np.mean(y_coords)
            y_centroid = int(np.round(y_centroid))
            centroid_1D[i] = y_centroid
            if show_centroid:
                cv2.circle(output_img, (i,y_centroid),5, centroid_color, 1)# display centroid
    return centroid_1D

def fill_in_missing_points(y_init, input_1D, output_1D, output_img, show_fill_blanks, fill_blanks_color):
    # fill in missing points
    x_prev = 0
    y_prev = y_init
    savepoint = 0
    firstpoint = [] # for filling filter padding to the left
    create_line = 0
    first_point = 0
    for i in range(dimensions[1]):
        y_value = input_1D[i]
        if first_point == 0:
            if input_1D[i] == 0:
                y_value = y_init
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
    line = np.linspace(y_init, y_init, line_len)
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

try:
    print('Starting video. Press q to exit.')
    frame_num = 0
    while True:
        frame_num += 1
        time_start = time.time()
        current_frame_gray = cv2.cvtColor(current_frame, cv2.COLOR_BGR2GRAY)
        # diff and mask
        frame_diff = cv2.subtract(current_frame_gray,previous_frame_gray)
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
        centroid_1D = centroid_1D_from_img(binary_img, wave_img, show_centroid, centroid_color)
        # fill in any blanks in the wave
        filter_padding = 50
        #if noise_gate == 0:
        #    wave_1D = prev_wave_1D
        #else:
        #    prev_binary_img = binary_img
        #    wave_1D = np.zeros(dimensions[1]+filter_padding*2)
        wave_1D = np.zeros(dimensions[1]+filter_padding*2)
        wave_1D = fill_in_missing_points(wavecenter_y_left, centroid_1D, wave_1D, wave_img, show_fill_blanks, fill_blanks_color)
        # median filtering
        filter_size1 = 29
        #wave_1D = median_filter(wave_1D, size=filter_size1)
        # lowpass
        filter_size = 40
        #wave_1D = lowpass_1D(wave_1D, wave_img, show_lowpassfilter, lowpass_color)
        prev_wave_1D = wave_1D
        # crop filter padding
        wave_1D = wave_1D[filter_padding:-filter_padding]
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

        # Display result
        output = cv2.add(current_frame, wave_img)    
        if show_mask:
            polyg_show = cv2.polylines(output,pts=[pts],isClosed=True, color=(255,0,0),thickness=2)
        # add labels
        v_offset = 20
        legend_x = 15
        legend_y = 15
        if show_centroid:
            cv2.circle(output, (legend_x,legend_y), 4, centroid_color, 4)
            cv2.putText(output, 'centroid', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, centroid_color, 1, cv2.LINE_AA)
            legend_y += v_offset
        if show_fill_blanks:
            cv2.circle(output, (legend_x,legend_y), 4, fill_blanks_color, 4)
            cv2.putText(output, 'fill', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, fill_blanks_color, 1, cv2.LINE_AA)
            legend_y += v_offset
        if show_lowpassfilter:
            cv2.circle(output, (legend_x,legend_y), 4, lowpass_color, 4)
            cv2.putText(output, 'lowpass', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, lowpass_color, 1, cv2.LINE_AA)
            legend_y += v_offset
        if show_wavecenter:
            cv2.circle(output, (legend_x,legend_y), 4, wavecenter_color, 4)
            cv2.putText(output, 'centerline', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, wavecenter_color, 1, cv2.LINE_AA)
            legend_y += v_offset
        if show_wavesign:
            cv2.circle(output, (legend_x,legend_y), 4, wavesign_color, 4)
            cv2.putText(output, 'wavesign', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, wavesign_color, 1, cv2.LINE_AA)
            legend_y += v_offset
        if show_fft:
            for i in range(int(len(fftr)/8)):
                if i < 11: fft_color = orange
                elif i < 30: fft_color = green
                else: fft_color = blue
                cv2.circle(output, ((i*16), dimensions[0]-int(fftr[i])), 4, fft_color, 4)
        if show_stats:
            cv2.putText(output, f'numpeaks: {numpeaks}', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            cv2.putText(output, f'avg_x_dist: {avg_x_distance:.2f}, avg movement {avg_x_movement:.2f}', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            x_pos_disp = 'x_pos :'
            for x in x_pos:
                x_pos_disp = x_pos_disp + f'{x:.2f}' + ', '
            cv2.putText(output, x_pos_disp, (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            x_dist_disp = 'x_dist :'
            for x in x_distances:
                x_dist_disp = x_dist_disp + f'{x:.2f}' + ', '
            cv2.putText(output, x_dist_disp, (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            zc = ''
            for z in zero_crossings[0]:
                zc = zc + f'{z:.2f} ' 
            cv2.putText(output, f'zero_cross: {zc}', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            zc_disp = 'zc_dist: '
            for i in zc_diff:
                zc_disp = zc_disp + f'{i:.2f}' + ', '
            cv2.putText(output, zc_disp, (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
            legend_y += v_offset*2
            cv2.putText(output, f'wave activity {wave_activity:.2f}', (legend_x+15,legend_y+5), cv2.FONT_HERSHEY_SIMPLEX, 1, stats_color, 1, cv2.LINE_AA)
        if show_binary:
            binary_img_bgr = cv2.cvtColor(binary_img, cv2.COLOR_GRAY2BGR)
            output = cv2.add(output, binary_img_bgr)    
        time_labels = time.time()
        output = cv2.resize(output, size)
        cv2.imshow("Rope", output)
        time_output = time.time()
        previous_frame_gray = current_frame_gray.copy()
        ret, current_frame = cap.read() 
        if flip:
            current_frame = cv2.flip(current_frame,-1)
        if not ret:
            break

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
        key = cv2.waitKey(wait_time)

        if key == ord('q'):
            break
        if key == ord('p'):
            cv2.waitKey(-1) #wait until any key is pressed

except KeyboardInterrupt:
    #cap.release()
    cv2.destroyAllWindows()
print('Done.')
