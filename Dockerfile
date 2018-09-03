#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

RUN dpkg --add-architecture i386 && apt update && apt install -y wine wine32
RUN wine wineboot --init
RUN wine --version
RUN apt install -y unzip wget curl

RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget https://services.gradle.org/distributions/gradle-4.7-bin.zip && \
	unzip gradle-4.7-bin.zip && \
	rm -f gradle-4.7-bin.zip

RUN mkdir -p /root/.wine/drive_c/dev/ && \
	cd /root/.wine/drive_c/dev/ && \
	wget https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.181-1/java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
	unzip java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip && \
	rm -f java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip
