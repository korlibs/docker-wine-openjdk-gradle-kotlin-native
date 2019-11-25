#!/bin/bash
docker build . -t soywiz/kotlin-native-win:latest
docker build . -t soywiz/kotlin-native-win:java8
docker build . -t soywiz/kotlin-native-win:opengl-openal
