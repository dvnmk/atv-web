#!/bin/bash
  ffmpeg \
  -fflags +genpts \
  -f v4l2 \
  -use_wallclock_as_timestamps 1 \
  -input_format mjpeg \
  -video_size 1280x720 \
  -framerate 30 \
  -i /dev/v4l/by-id/usb-MACROSILICON_USB3_PLUS_Video_20210629-video-index0 \
  -f alsa \
  -use_wallclock_as_timestamps 1 \
  -ar 48000 \
  -ac 2 \
  -i sysdefault:CARD=Video \
  -c:v libx264 \
  -preset faster \
  -tune zerolatency \
  -g 30 \
  -keyint_min 30 \
  -b:v 1800k \
  -maxrate 2200k \
  -bufsize 3600k \
  -pix_fmt yuv420p \
  -c:a aac \
  -b:a 96k \
  -af "aresample=async=1:first_pts=0" \
  -rtsp_transport tcp \
  -muxdelay 0 \
  -f rtsp \
  rtsp://127.0.0.1:8554/webcam
  
