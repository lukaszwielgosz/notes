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

ffplay -f rawvideo -pixel_format yuyv422 -framerate 15 -video_size 160x120 -fs -i udp://127.0.0.1:5000

```

```
ffmpeg -sdp_file video.sdp -protocol_whitelist file,crypto,udp,rtp -f v4l2 -pixel_format yuyv422 -video_size 320x240 -framerate 15 -i /dev/video2 -f rtp rtp://127.0.0.1:5000

ffplay -sdp_file video.sdp -f rtp -pixel_format yuyv422 -framerate 15 -video_size 320x240 -fs -i rtp://127.0.0.1:5000
```


ffmpeg -sdp_file video.sdp -protocol_whitelist file,crypto,udp,rtp -f v4l2 -pixel_format yuyv422 -video_size 320x240 -framerate 15 -i /dev/video0 -f rtp rtp://192.168.0.103:5000

