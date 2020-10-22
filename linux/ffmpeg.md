Detect devices, list device capabilities
```
v4l2-ctl --list-devices
ffmpeg -f v4l2 -list_formats all -i /dev/video0
```

Try play stream
```
ffplay /dev/video2
```

## Streaming
```
ffmpeg -f v4l2 -pixel_format yuyv422 -video_size 320x240 -framerate 15 -i /dev/video2 -f rawvideo udp://127.0.0.1:5000


ffplay -f rawvideo -pixel_format yuyv422 -framerate 15 -video_size 320x240 -fs -i udp://127.0.0.1:5000
```

```
ffmpeg -sdp_file video.sdp -protocol_whitelist file,crypto,udp,rtp -f v4l2 -pixel_format yuyv422 -video_size 320x240 -framerate 15 -i /dev/video2 -f rtp rtp://127.0.0.1:5000

ffplay -i video.sdp -protocol_whitelist file,udp,rtp
```

```
ffmpeg -sdp_file video.sdp -protocol_whitelist file,crypto,udp,rtp -f v4l2 -pixel_format yuyv422 -video_size 160x120 -framerate 15 -i /dev/video0 -f rtp rtp://127.0.0.1:5000

```



### MJPEG TX

```
ffmpeg -f v4l2 -pixel_format yuyv422 -video_size 176x144 -framerate 15 -i /dev/video0 -c:v mjpeg -q:v 1 -f mjpeg udp://192.168.3.198:5000

ffmpeg -f v4l2 -pixel_format yuyv422 -video_size 176x144 -framerate 15 -i /dev/video1 -c:v mjpeg -q:v 1 -f mjpeg udp://192.168.0.101:5000

ffmpeg -f v4l2 -pixel_format yuyv422 -video_size 176x144 -framerate 15 -i /dev/video0 -vcodec mjpeg -q:v 1 -f rtp rtp://192.168.3.198:5000
```

### MJPEG RX:
```
ffplay -f mjpeg -i udp://127.0.0.1:5000
```
or
```
gst-launch-1.0 udpsrc port=5000 ! jpegparse ! jpegdec ! queue ! videoconvert ! autovideosink sync=false
```



