#!/bin/bash

[[ $(id -u) -ne 0 ]] && echo "must be run as root" && exit 2

LAST_DISPLAY=$(ls /tmp/.X11-unix/ | sort | tail -n 1 | tail -c +2 | head -c -1)
DISPLAY=$((LAST_DISPLAY+1))
vt=8

Xorg -configure
Xorg :$DISPLAY vt$vt \
  -dpms -s off -retro \
  +extension RANDR \
  +extension RENDER \
  +extension GLX \
  +extension XVideo \
  +extension DOUBLE-BUFFER \
  +extension SECURITY \
  +extension DAMAGE \
  -extension X-Resource \
  -extension XINERAMA -xinerama \
  -extension MIT-SHM \
  -nolisten tcp \
  +extension Composite +extension COMPOSITE \
  -extension XTEST -tst \
  -dpi 96 \
  -verbose \
  -quiet &

docker run \
    --name kali \
    --hostname kali \
    -e DISPLAY=:$DISPLAY \
    -v /tmp/.X11-unix/X$DISPLAY:/tmp/.X11-unix/X$DISPLAY:rw \
    --rm \
    -v /dev:/dev \
    -v /etc/localtime:/etc/localtime:ro \
    -v /home/felix/CTF:/home/kali/CTF \
    --net=host \
    --ipc=host \
    --privileged \
    defelo/kali

pid=$(ps -C Xorg | grep tty$vt | awk '{print $1;}')
kill $pid
