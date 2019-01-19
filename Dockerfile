#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

# Required environments
ENV WINEPREFIX=/root/.wine
ENV WINEDEBUG=-all
ENV DEBIAN_FRONTEND=noninteractive

# Install wine and tools, and initialize wine
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y wine wine32 wine64 unzip wget curl nano libtinfo-dev libtinfo5 && \
	wine wineboot --init && \
	wineserver -w && \
	sleep 5

# Install openjdk to compile for linux too
RUN apt-get install -y openjdk-11-jdk

RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/11.0.1-1/java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	unzip java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	rm -f java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	mv java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64 java && \
	rm java/lib/src.zip

# Set JAVA_HOME and PATH environment variables with gradle and jav, and wait wineserver for 5 seconds to flush files
RUN cd /root && \
	export WINE_PATH="C:\\windows\\system32;C:\\windows;C:\\windows\\system32\\wbem;C:\\dev\\gradle\\bin;C:\\dev\\java\\bin" && \
	wine reg add "HKEY_CURRENT_USER\\Environment" /v JAVA_HOME /t REG_SZ /d c:\\dev\\java && \
	wine reg add "HKEY_CURRENT_USER\\Environment" /v PATH /t REG_SZ /d $WINE_PATH && \
	wineserver -w && \
	sleep 5

# Add gradle-win and winecmd tools
RUN cd /usr/local/bin && \
	echo "#!/bin/bash\nwine cmd /c gradle \$*" > gradle-win && \
	echo "#!/bin/bash\nwine cmd /c \$*" > winecmd && \
	chmod +x gradle-win winecmd

# Create .gradle, .konan and .m2, and instructions to not use the gradle daemon
RUN cd /root && \
	mkdir -p /root/.wine/drive_c/users/root/.gradle && \
	mkdir -p /root/.wine/drive_c/users/root/.konan && \
	mkdir -p /root/.wine/drive_c/users/root/.m2 && \
	mkdir -p /root/.gradle && \
	mkdir -p /root/.konan && \
	mkdir -p /root/.m2 && \
	mkdir -p /root/.gradle_properties && echo 'org.gradle.daemon=false' > /root/.gradle_properties/gradle.properties echo ln -s /root/.gradle_properties/gradle.properties /root/.gradle/gradle.properties && \
	mkdir -p /root/.wine/drive_c/users/root/.gradle_properties && echo 'org.gradle.daemon=false' > /root/.wine/drive_c/users/root/.gradle_properties/gradle.properties echo ln -s /root/.gradle_properties/gradle.properties /root/.wine/drive_c/users/root/.gradle/gradle.properties

# Volumes for wine
VOLUME ["/root/.wine/drive_c/users/root/.gradle"]
VOLUME ["/root/.wine/drive_c/users/root/.gradle_properties"]
VOLUME ["/root/.wine/drive_c/users/root/.konan"]
VOLUME ["/root/.wine/drive_c/users/root/.m2"]

# Volumes for linux
VOLUME ["/root/.gradle"]
VOLUME ["/root/.gradle_properties"]
VOLUME ["/root/.konan"]
VOLUME ["/root/.m2"]

# Volume that will held the work, usually mounted with "-v$PWD:/work"
VOLUME ["/work"]

WORKDIR /work
