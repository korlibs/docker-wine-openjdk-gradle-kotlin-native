## docker-wine-openjdk-gradle-kotlin-native

This container includes gradle, openjdk and wine in a single image and provides some useful things
to compile windows libraries and executables of Kotlin/Native projects.

This docker is built automatically here: <https://hub.docker.com/r/soywiz/kotlin-native-win/>

## Build and run HelloWorld

```bash
pushd hello-world
./gradlew_win compileKonan
./wine build/konan/bin/mingw_x64/HelloWorld.exe
popd
```

## [`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win)

[`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win) 
is a small script that you can copy to your project where the `gradlew.bat` file is, and it will launch
gradle for windows in the container.

You can try to change the `SUFFIX=-win` to `SUFFIX=` to your host folders to reuse things,
but be careful since that might screw things (untested).

## [`./wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine)

[`./wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine) 
is a small script that you to run a headless wine inside the container to test cli windows application
you can place it along the gradlew_win script to run your generated programs without having to install
wine in your host.
