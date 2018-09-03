#!/bin/bash
pushd hello-world
./gradlew_win compileKonan
./wine build/konan/bin/mingw_x64/HelloWorld.exe
popd
