#!/bin/bash

[[ $# -lt 2 ]] && echo "usage: $0 <first display> <second display>" && exit 1

clipread() {
    xclip -selection clip -r -o -display $1 2> /dev/null
}

clipwrite() {
    xclip -selection clip -r -i -display $1
}

clipboard=

update() {
    content=$(clipread $1)
    if [[ "$content" != "$clipboard" ]]
    then
        clipboard=$content
        clipwrite $2 <<< "$content"
    fi
}

while true
do
    update $1 $2
    sleep .1
    update $2 $1
    sleep .1
done
