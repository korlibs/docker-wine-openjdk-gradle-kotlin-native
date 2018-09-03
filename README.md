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

## 
[`gradlew-win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew-win)

[`gradlew-win`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/gradlew-win) 
is a small script that you can copy to your path to invoke `gradlew.bat` in the current folder inside the
container.
