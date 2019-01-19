## docker-wine-openjdk-gradle-kotlin-native

This container includes gradle, openjdk and wine in a single image and provides some useful things
to compile windows and linux libraries and executables of Kotlin/Native projects.

This docker is built automatically here: <https://hub.docker.com/r/soywiz/kotlin-native-win/>

## Build and run HelloWorld

```bash
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
```

## [`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win)

[`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win) 
is a small script that you can copy to your project where the `gradlew.bat` file is, and it will launch
gradle for windows in the container.

You can try to change the `SUFFIX=-win` to `SUFFIX=` to your host folders to reuse things,
but be careful since that might screw things (untested).

## [`gradlew_linux`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_linux)

[`gradlew_linux`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_linux) 
is a small script that you can copy to your project where the `gradlew` file is, and it will launch
gradle for linux in the container.

## [`./win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/win)

[`./win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/win) 
is a small script that you to run a headless wine inside the container to test cli windows application
you can place it along the gradlew_win script to run your generated programs without having to install
wine in your host.

## [`./linux`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/linux)

[`./linux`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/linux) 
is a small script that you to run a linux command you can place it along the gradlew_linux script to run
your generated linux programs.

## `./gradlew_wine`

If you have WINE installed, and the oraclejdk or openjdk installed, you can use `gradlew_wine`. It will run faster.

You can also place symbolik links from your `.wine` prefix `.gradle`, `.m2`, `.konan` to your user's host folder
to be able to reuse artifacts.

Delete or remoname `$HOME/.wine/drive_c/users/$USERNAME/.gradle`m `.m2` and `.konan` folders before doing
the symbolic linking in the case they exists already.

## `gradlew_copy_gradle_properties`

If you want to copy your system's gradle.properties to be used inside linux and windows gradlew, you can call this bash script.
It helps for example if you have properties for publishing/deploying.
