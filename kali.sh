#!/bin/bash

[[ $(id -u) -ne 0 ]] && echo "must be run as root" && exit 2

LAST_DISPLAY=$(ls /tmp/.X11-unix/ | sort | tail -n 1 | tail -c +2 | head -c -1)
DISP=$((LAST_DISPLAY+1))

Xephyr -keybd ephyr,,,xkbmodel=pc105,xkblayout=de,xkbrules=evdev,xkboption=grp:alts_toogle -ac -br -fullscreen :$DISP &
pid=$!

sleep 1

docker run \
    --name kali \
    --hostname kali \
    -e DISPLAY=:$DISP \
    -v /tmp/.X11-unix/X$DISP:/tmp/.X11-unix/X$DISP:rw \
    --rm \
    -v /etc/localtime:/etc/localtime:ro \
    -v /home/felix/CTF:/home/kali/CTF \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --privileged \
    defelo/kali:xephyr

kill $pid
