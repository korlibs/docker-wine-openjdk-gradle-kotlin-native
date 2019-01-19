#!/bin/bash
pushd hello-world

echo Building and running windows...
./gradlew_win compileKonan
win build/konan/bin/mingw_x64/HelloWorld.exe

echo Building and running linux...
./gradlew_linux compileKonan
./linux build/konan/bin/linux_x64/HelloWorld.kexe

popd
