## docker-wine-openjdk-gradle-kotlin-native

This container includes gradle, openjdk and wine in a single image and provides some useful things
to compile windows and linux libraries and executables of Kotlin/Native projects.

This docker is built automatically here: <https://hub.docker.com/r/soywiz/kotlin-native-win/>

## Build and run HelloWorld

```bash
pushd hello-world

echo Building and running windows...
./gradlew_win compileKonan
./wine build/konan/bin/mingw_x64/HelloWorld.exe

echo Building and running linux...
./gradlew_linux compileKonan
./linux build/konan/bin/linux_x64/HelloWorld.kexe

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

## [`./wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine)

[`./wine`](https://github.com/soywiz/docker-wine-openjdk-gradle-kotlin-native/blob/master/wine) 
is a small script that you to run a headless wine inside the container to test cli windows application
you can place it along the gradlew_win script to run your generated programs without having to install
wine in your host.

## `./gradlew_wine`

If you have WINE installed, and the oraclejdk or openjdk installed, you can use `gradlew_wine`. It will run faster.

You can also place symbolik links from your `.wine` prefix `.gradle`, `.m2`, `.konan` to your user's host folder
to be able to reuse artifacts.

Delete or remoname `$HOME/.wine/drive_c/users/$USERNAME/.gradle`m `.m2` and `.konan` folders before doing
the symbolic linking in the case they exists already.

~
```
#ln -s $HOME/.gradle $HOME/.wine/drive_c/users/$USERNAME/.gradle # doesn't look like a good idea because there is information about the daemons
ln -s $HOME/.m2 $HOME/.wine/drive_c/users/$USERNAME/.m2
ln -s $HOME/.konan $HOME/.wine/drive_c/users/$USERNAME/.konan
```
~

