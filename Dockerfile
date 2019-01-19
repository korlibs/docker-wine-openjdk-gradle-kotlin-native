#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

ARG GRADLE_VERSION=5.1.1

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

# Install gradle
#RUN mkdir -p /root/.wine/drive_c/dev/ && \
#	cd /root/.wine/drive_c/dev/ && \
#	wget --quiet https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
#	unzip gradle-$GRADLE_VERSION-bin.zip && \
#	rm -f gradle-$GRADLE_VERSION-bin.zip && \
#	mv gradle-$GRADLE_VERSION gradle

# Install openjdk 
#RUN mkdir -p /root/.wine/drive_c/dev/ && \
#	cd /root/.wine/drive_c/dev/ && \
#	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.181-1/java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
#	unzip java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
#	rm -f java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
#	mv java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64 java

RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/11.0.1-1/java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	unzip java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	rm -f java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
	mv java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64 java && \
	rm java/lib/src.zip

# Install oraclejdk (after accepting the binary license) - http://www.oracle.com/technetwork/java/javase/terms/license/index.html
#ADD jdk1.8.0_181.zip /root/
#RUN mkdir -p /root/.wine/drive_c/dev/ && \
#	cd /root/.wine/drive_c/dev/ && \
#	unzip /root/jdk1.8.0_181.zip && \
#	mv jdk1.8.0_181 java

#ADD registry.reg /root/
#RUN wine regedit /root/registry.reg

#wine reg query HKEY_CURRENT_USER\\Environment

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

# Compile a hello world project with Kotlin-native, so it downloads gradle, and all the kotlin/Native dependencies
# Should not e required since the .gradle folder is a volume?
#COPY hello-world /root/hello-world
#RUN cd /root/hello-world && \
#	winecmd gradlew.bat compileKonan && \
#	rm -rf /root/hello-world && \
#	gradle-win --stop && \
#	sleep 3

# Create .gradle, .konan and .m2, and instructions to not use the gradle daemon
RUN cd /root && \
	mkdir -p /root/.wine/drive_c/users/root/.gradle && \
	mkdir -p /root/.wine/drive_c/users/root/.konan && \
	mkdir -p /root/.wine/drive_c/users/root/.m2 && \
	mkdir -p /root/.gradle && \
	mkdir -p /root/.konan && \
	mkdir -p /root/.m2 && \
	echo 'org.gradle.daemon=false' > /root/.wine/drive_c/users/root/.gradle/gradle.properties && \
	echo 'org.gradle.daemon=false' > /root/.gradle/gradle.properties

RUN cp -rf /root/. /root.bak

# Volume with all the gradle stuff
# Volume with all the konan stuff
# Volume with all the maven stuff (useful for publishing to maven local)
#VOLUME ["/root/.wine/drive_c/users/root/.gradle"]
#VOLUME ["/root/.wine/drive_c/users/root/.konan"]
#VOLUME ["/root/.wine/drive_c/users/root/.m2"]

# Volumes for linux
#VOLUME ["/root/.gradle"]
#VOLUME ["/root/.konan"]
#VOLUME ["/root/.m2"]

VOLUME ["/root"]

# Volume that will held the work, usually mounted with "-v$PWD:/work"
VOLUME ["/work"]

WORKDIR /work

RUN echo "#!/bin/bash\nif [ ! -d /root/.wine ]; then\ncp -r /root.bak/. /root\nfi" > /root.bak/prepare.sh && chmod +x /root.bak/prepare.sh
