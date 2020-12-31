# Gstreamer commands
http://wiki.oz9aec.net/index.php/Gstreamer_cheat_sheet

List device formats options etc
```sh
gst-device-monitor-1.0 Video/Source
```
## videotestsrc

```sh
gst-launch-1.0 videotestsrc pattern=0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videoconvert ! autovideosink
```

### pattern
smpte (0) – SMPTE 100%% color bars
snow (1) – Random (television snow)
black (2) – 100%% Black
white (3) – 100%% White
red (4) – Red
green (5) – Green
blue (6) – Blue
checkers-1 (7) – Checkers 1px
checkers-2 (8) – Checkers 2px
checkers-4 (9) – Checkers 4px
checkers-8 (10) – Checkers 8px
circular (11) – Circular
blink (12) – Blink
smpte75 (13) – SMPTE 75%% color bars
zone-plate (14) – Zone plate
gamut (15) – Gamut checkers
chroma-zone-plate (16) – Chroma zone plate
solid-color (17) – Solid color
ball (18) – Moving ball
smpte100 (19) – SMPTE 100%% color bars
bar (20) – Bar
pinwheel (21) – Pinwheel
spokes (22) – Spokes
gradient (23) – Gradient
colors (24) – Colors

## USB camera

PS3Eye
30fps
```sh
gst-launch-1.0 v4l2src device=/dev/video2 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videoconvert ! autovideosink
```
60fps
```sh
gst-launch-1.0 v4l2src device=/dev/video2 ! video/x-raw,width=640,height=480,framerate=60/1 ! videoconvert ! autovideosink
```

## Stream h264
```sh
gst-launch-1.0 videotestsrc ! videoconvert ! x264enc bitrate=4000 ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=127.0.0.1 port=5602 -e
```

### Webcam
```sh
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videoconvert ! "video/x-raw, format=I420" ! x264enc bitrate=4000 tune=zerolatency ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=127.0.0.1 port=5602 -e

gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videoconvert ! x264enc bitrate=4000 tune=zerolatency ! video/x-h264,profile=main ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=127.0.0.1 port=5602 -e
```

```sh
gst-launch-1.0 videotestsrc ! omxh264enc ! \
 'video/x-h264, stream-format=(string)byte-stream' ! h264parse !  rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=192.168.0.12 port=5602 -e
```


## View h264 udp stream
```sh
gst-launch-1.0 udpsrc port=5602 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink sync=false

gst-launch-1.0 udpsrc port=560 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' \
               ! rtph264depay ! avdec_h264 ! clockoverlay valignment=bottom ! autovideosink fps-update-interval=1000 sync=false

```
## view h265 udp stream
```
gst-launch-1.0 udpsrc port=5602 ! application/x-rtp,encoding-name=H265,payload=96 ! rtph265depay ! h265parse ! libde265dec ! autovideosink sync=false
```

```
gst-launch-1.0 udpsrc port=5602 ! application/x-rtp,encoding-name=H265,payload=96 ! rtpjitterbuffer ! rtph265depay ! h265parse ! libde265dec ! autovideosink sync=false
```

# Jetson

## grabber
```sh
gst-launch-1.0 v4l2src device=/dev/video2 ! image/jpeg, width=1920,height=1080,framerate=\(fraction\)30/1 ! jpegparse ! jpegdec ! videoconvert ! autovideosink sync=false

gst-launch-1.0 v4l2src device=/dev/video2 ! image/jpeg, width=1280,height=720,framerate=\(fraction\)60/1 ! jpegparse ! jpegdec ! videoconvert ! autovideosink sync=false
```

### mjpeg camera
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg, width=1920,height=1080,framerate=\(fraction\)30/1 ! jpegparse ! jpegdec ! videoconvert ! autovideosink
```
### videotestsrc
h264
```
gst-launch-1.0 videotestsrc ! nvvidconv ! nvv4l2h264enc control-rate=1 bitrate=30000000 ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=192.168.0.105 port=5602 -e

gst-launch-1.0 videotestsrc ! nvvidconv ! nvv4l2h264enc control-rate=1 bitrate=30000000 preset-level=1 profile=4 ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=192.168.0.105 port=5602 -e

gst-launch-1.0 videotestsrc ! nvvidconv ! nvv4l2h264enc control-rate=1 bitrate=30000000 preset-level=1 profile=4 ! rtph264pay ! "application/x-rtp,payload=(int)103,clock-rate=(int)90000" ! udpsink host=127.0.0.1 port=5602 -e
```

h265
```
gst-launch-1.0 videotestsrc ! nvvidconv ! nvv4l2h265enc control-rate=1 bitrate=30000000 preset-level=1 profile=0 insert-sps-pps=1 maxperf-enable=1 ! rtph265pay ! udpsink host=192.168.0.101 port=5602 -e


gst-launch-1.0 videotestsrc ! video/x-raw,width=1920,height=1080,framerate=\(fraction\)30/1 ! nvvidconv ! nvv4l2h265enc control-rate=1 bitrate=30000000 preset-level=1 profile=0 insert-sps-pps=1 maxperf-enable=1 ! rtph265pay ! udpsink host=192.168.0.101 port=5602 -e
```

h265 + mjpeg camera
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg, width=1920,height=1080,framerate=\(fraction\)30/1 ! jpegparse ! jpegdec ! nvvidconv ! nvv4l2h265enc control-rate=1 bitrate=2000000 preset-level=1 profile=0 insert-sps-pps=1 maxperf-enable=1 ! rtph265pay ! udpsink host=192.168.0.101 port=5602 -e
```

h265 + grabber
```
gst-launch-1.0 v4l2src device=/dev/video2 ! image/jpeg, width=1920,height=1080,framerate=\(fraction\)30/1 ! jpegparse ! jpegdec ! nvvidconv ! nvv4l2h265enc control-rate=1 bitrate=2000000 preset-level=1 profile=0 insert-sps-pps=1 maxperf-enable=1 ! rtph265pay ! udpsink host=192.168.0.101 port=5602 -e
```


## decode

```
gst-launch-1.0 udpsrc port=5602 ! application/x-rtp,encoding-name=H265,payload=96 ! rtph265depay ! h265parse ! nvv4l2decoder enable-max-performance=1 ! autovideosink sync=false
```

## mixer
based on
```
gst-launch-1.0 videotestsrc pattern=0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videoconvert ! autovideosink
```

side by side
```
gst-launch-1.0 videomixer name=mix ! videoconvert ! autovideosink videotestsrc pattern=0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! videobox left=-642 border-alpha=0 ! queue ! mix. videotestsrc pattern=0 ! video/x-raw,width=640,height=480,framerate=\(fraction\)30/1 ! queue ! mix.
```

up down
```
gst-launch-1.0 videomixer name=mix ! videoconvert ! autovideosink videotestsrc pattern=0 ! video/x-raw,width=1280,height=720,framerate=\(fraction\)30/1 ! videobox top=-724 border-alpha=0 ! queue ! mix. videotestsrc pattern=0 ! video/x-raw,width=1280,height=720,framerate=\(fraction\)30/1 ! queue ! mix.
```