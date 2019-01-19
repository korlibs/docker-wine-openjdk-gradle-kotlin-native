#!/usr/bin/env bash

export CMD=$1
export VOLUME=$2
export FILE=$3

if [ "$CMD" == "" ] || [ "$VOLUME" == "" ] || [ "$FILE" == "" ]; then
    echo "Missing argument/s: $0 [ls|rm|get|put] volume file"
    exit
fi

export BASE=`basename $FILE`

if [ "$CMD" == "ls" ]; then
docker run --rm -i -v "$VOLUME:/tmp/myvolume" busybox ls -la /tmp/myvolume/$FILE
elif [ "$CMD" == "cat" ]; then
docker run --rm -i -v "$VOLUME:/tmp/myvolume" busybox cat /tmp/myvolume/$FILE
elif [ "$CMD" == "rm" ]; then
docker run --rm -i -v "$VOLUME:/tmp/myvolume" busybox rm -rf /tmp/myvolume/$FILE
elif [ "$CMD" == "get" ]; then
docker run --rm -i -v "$VOLUME:/tmp/myvolume" -v "$PWD:/tmp/local" busybox cp /tmp/myvolume/$FILE /tmp/local/$BASE
elif [ "$CMD" == "put" ]; then
docker run --rm -i -v "$VOLUME:/tmp/myvolume" -v "$PWD:/tmp/local" busybox cp /tmp/local/$BASE /tmp/myvolume/$FILE
else
    echo Command must be get, por, ls, rm, cat
fi

#docker run --rm -i -v "$1:/tmp/myvolume" -v "$PWD:/tmp/local" busybox ls -la /tmp/myvolume/$2
