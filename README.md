## docker-wine-openjdk-gradle-kotlin-native

This docker is built automatically here: <https://hub.docker.com/r/soywiz/kotlin-native-win/>

To use, you have to execute the following command in a folder with a `gradlew.bat` file and a `build.gradle` or `build.gradle.kts` 
using Kotlin/Native:

```
docker run "-v$PWD:/work" soywiz/kotlin-native-win:0.8.2 winecmd gradlew.bat compileKonan
```

It will execute gradle with openjdkfor windows using wine inside a docker container :)

To preserve gradle and konan downloads, artifacts and caches between calls:

```
docker run -it \
	"-v$PWD:/work" \
	"-v$HOME/.gradle-win:/root/.wine/drive_c/users/root/.gradle" \
	"-v$HOME/.konan-win:/root/.wine/drive_c/users/root/.konan" \
	soywiz/kotlin-native-win:0.9-rc1-3632 \
	winecmd gradlew.bat compileKonan
```

It should be possible to reuse your .gradle and .konan folders, but do it at your own risk:

```
docker run -it \
        "-v$PWD:/work" \
        "-v$HOME/.gradle:/root/.wine/drive_c/users/root/.gradle" \
        "-v$HOME/.konan:/root/.wine/drive_c/users/root/.konan" \
        soywiz/kotlin-native-win:0.9-rc1-3632 \
        winecmd gradlew.bat compileKonan
```

If you want to disable the pointless gradle daemon, add the following line to the `~/.gradle-win/gradle.properties` (create if not exists):

```
org.gradle.daemon=false
```

## [`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win)

[`gradlew_win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew_win) 
is a small script that you can copy to your project where the `gradlew.bat` file is, and it will launch
gradle for windows in the container.

## [`wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine)

[`wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine) 
is a small script that you to run a headless wine inside the container to test cli windows application
you can place it along the gradlew_win script to run your generated programs without having to install
wine in your host.
