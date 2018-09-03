#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
docker run "-v$DIR/hello-world:/work" soywiz/kotlin-native-win:0.8.2 winecmd gradlew.bat compileKonan

