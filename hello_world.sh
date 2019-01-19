#!/bin/bash
pushd hello-world

echo Building java, macos, windows, linux...
./gradlew fatJar
./gradlew linkTestDebugExecutableMacosX64
./gradlew_win linkTestDebugExecutableMingwX64
./gradlew_linux linkTestDebugExecutableLinuxX64

echo Running macos, windows, linux...
java -jar build/libs/HelloWorld-all.jar
./build/bin/macosX64/main/debug/executable/HelloWorld.kexe
./win build/bin/mingwX64/main/debug/executable/HelloWorld.exe
./linux build/bin/linuxX64/main/debug/executable/HelloWorld.kexe

popd
