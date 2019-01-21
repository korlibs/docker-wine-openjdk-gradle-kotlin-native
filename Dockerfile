#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_HOME_LINUX=/home/user
ENV WINEPREFIX=$USER_HOME_LINUX/.wine
ENV WINEDEBUG=-all
ENV JAVA_HOME_WIN=$USER_HOME_LINUX/.wine/drive_c/dev/java
ENV USER_HOME_WINE=$USER_HOME_LINUX/.wine/drive_c/users/user

# Download all the required dependencies
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y openjdk-8-jdk unzip wget curl nano libtinfo-dev libtinfo5 wine wine32 wine64 zip && \
	chmod 0777 -R /usr/local/bin && \
	useradd -ms /bin/bash user

# Switch from root to user
USER user

# Initialize wine for user
RUN wine wineboot --init && wineserver -w && sleep 5

# Download openjdk8
# Patches openjdk8 RT java.nio.file.Files to circumvent the docker+wine+java bug/problem. Check java/nio/file/README.md for details.
ADD --chown=user java/nio/file/Files.java /tmp/java/nio/file/Files.java
RUN mkdir -p $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	cd $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.191-1/java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	unzip java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	rm -f java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	mv java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64 java && \
	rm java/src.zip && \
	cd $JAVA_HOME_WIN/jre/lib && \
	mkdir -p $JAVA_HOME_WIN/jre/lib/java/nio/file && \
	cp /tmp/java/nio/file/Files.java $JAVA_HOME_WIN/jre/lib/java/nio/file/Files.java && \
	javac -XDignore.symbol.file java/nio/file/Files.java && \
	jar uf rt.jar java && \
	rm -rf java

# Set JAVA_HOME and PATH environment variables with gradle and java, and wait wineserver for 5 seconds to flush files
RUN cd $USER_HOME_LINUX && \
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

# Create .gradle, .konan and .m2
RUN cd $USER_HOME_LINUX && \
	mkdir -p $USER_HOME_WINE/.gradle && \
	mkdir -p $USER_HOME_WINE/.konan && \
	mkdir -p $USER_HOME_WINE/.m2 && \
	mkdir -p $USER_HOME_LINUX/.gradle && \
	mkdir -p $USER_HOME_LINUX/.konan && \
	mkdir -p $USER_HOME_LINUX/.m2

# Volumes for wine
VOLUME ["$USER_HOME_WINE/.gradle"]
VOLUME ["$USER_HOME_WINE/.konan"]
VOLUME ["$USER_HOME_WINE/.m2"]

# Volumes for linux
VOLUME ["$USER_HOME_LINUX/.gradle"]
VOLUME ["$USER_HOME_LINUX/.konan"]
VOLUME ["$USER_HOME_LINUX/.m2"]

# Volume that will held the work, usually mounted with "-v$PWD:/work"
VOLUME ["/work"]

WORKDIR /work
