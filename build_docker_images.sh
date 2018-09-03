#!/bin/bash
docker build --build-arg KOTLIN_NATIVE_VERSION=0.9-rc1-3632 . -t soywiz/kotlin-native-win:0.9-rc1-3632
