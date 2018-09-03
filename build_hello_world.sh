#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
HOME=`echo ~`
docker run -it \
	"-v$DIR/hello-world:/work" \
	"-v$HOME/.gradle-win:/root/.wine/drive_c/users/root/.gradle" \
	"-v$HOME/.konan-win:/root/.wine/drive_c/users/root/.konan" \
	soywiz/kotlin-native-win \
	winecmd gradlew.bat compileKonan

