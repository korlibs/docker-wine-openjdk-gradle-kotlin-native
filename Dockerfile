#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

# Install wine and tools
RUN dpkg --add-architecture i386 && apt update && apt install -y wine wine32 wine64 unzip wget curl && wine wineboot --init

# Install openjdk 
RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.181-1/java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
	unzip java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
	rm -f java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
	mv java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64 java

# Install gradle
RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget --quiet https://services.gradle.org/distributions/gradle-4.7-bin.zip && \
	unzip gradle-4.7-bin.zip && \
	rm -f gradle-4.7-bin.zip && \
	mv gradle-4.7 gradle

ADD registry.reg /root/
RUN wine regedit /root/registry.reg

# Download Kotlin-native stuff
RUN echo 'plugins { id "org.jetbrains.kotlin.konan" version "0.8.2" }' > /root/build.gradle && JAVA_HOME=c:\\dev\\java wine cmd /c c:\\dev\\gradle\\bin\\gradle.bat
