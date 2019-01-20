#FROM alpine:3.8
FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y openjdk-11-jdk unzip wget curl nano libtinfo-dev libtinfo5 wine wine32 wine64
RUN apt-get install zip

ENV USER_HOME_LINUX=/home/user
ENV WINEPREFIX=$USER_HOME_LINUX/.wine
ENV WINEDEBUG=-all

RUN chmod 0777 -R /usr/local/bin
RUN useradd -ms /bin/bash user
USER user

RUN	wine wineboot --init && wineserver -w && sleep 5

ENV USER_HOME_WINE=$USER_HOME_LINUX/.wine/drive_c/users/user

#RUN mkdir -p $USER_HOME_LINUX/.wine/drive_c/dev/ && \
#	cd $USER_HOME_LINUX/.wine/drive_c/dev/ && \
#	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/11.0.1-1/java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
#	unzip java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
#	rm -f java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64.zip && \
#	mv java-11-openjdk-11.0.1.13-1.ojdkbuild.windows.x86_64 java && \
#	rm java/lib/src.zip

RUN mkdir -p $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	cd $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.191-1/java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	unzip java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	rm -f java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	mv java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64 java && \
	rm java/src.zip

# Patches Files to circumvent the bug
ADD java/nio/file/Files.class $JAVA_HOME_WIN/jre/lib/java/nio/file/Files.class
RUN cd $JAVA_HOME_WIN/jre/lib && jar uf rt.jar java/nio/file/Files.class


#RUN mkdir -p $USER_HOME/.wine/drive_c/dev/ && \
#	cd $USER_HOME/.wine/drive_c/dev/ && \
#	wget --quiet https://cdn.azul.com/zulu/bin/zulu11.29.3-ca-jdk11.0.2-win_x64.zip && \
#	unzip zulu11.29.3-ca-jdk11.0.2-win_x64.zip && \
#	rm -f zulu11.29.3-ca-jdk11.0.2-win_x64.zip && \
#	mv zulu11.29.3-ca-jdk11.0.2-win_x64 java && \
#	rm java/lib/src.zip

# Set JAVA_HOME and PATH environment variables with gradle and jav, and wait wineserver for 5 seconds to flush files
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

ENV JAVA_HOME_WIN=$USER_HOME_LINUX/.wine/drive_c/dev/java

#RUN rm $JAVA_HOME_WIN/jre/lib/rt.jar

#ADD sun/nio/zipfs/ZipFileSystem.class $JAVA_HOME_WIN/jre/lib/ext/sun/nio/zipfs/ZipFileSystem.class
#RUN cd $JAVA_HOME_WIN/jre/lib/ext && jar uf zipfs.jar sun/nio/zipfs/ZipFileSystem.class

#RUN wine java -Xshare:dump && wineserver -w && sleep 5

#RUN find $USER_HOME_LINUX/.wine/drive_c/dev/java && echo 1

#RUN jmod extract $JAVA_HOME_WIN/jmods/java.base.jmod --dir $JAVA_HOME_WIN/jmods
#RUN jmod extract $JAVA_HOME_WIN/jmods/jdk.unsupported.jmod --dir $JAVA_HOME_WIN/jmods
#ADD sun/nio/fs/WindowsFileSystemProvider.class $JAVA_HOME_WIN/jmods/classes/sun/nio/fs/WindowsFileSystemProvider.class
#RUN ls -la $JAVA_HOME_WIN/jmods/java.base/classes/sun/nio/fs
#RUN cd $JAVA_HOME_WIN/jmods/java.base && zip -r ../java.base.zip *
#RUN rm -rf $JAVA_HOME_WIN/jmods/java.base
#ADD JMOD_HEADER $JAVA_HOME_WIN/jmods/JMOD_HEADER
#RUN cd $JAVA_HOME_WIN/jmods && cat JMOD_HEADER java.base.zip > java.base.jmod
#RUN rm $JAVA_HOME_WIN/jmods/java.base.jmod
#RUN cd $JAVA_HOME_WIN && wine jlink --module-path jmods/java.base --add-modules java.base,jdk.unsupported --output new_jre
#RUN cp -rf $JAVA_HOME_WIN/new_jre/lib/* $JAVA_HOME_WIN/lib/


#RUN winecmd java -version

#RUN cd $USER_HOME_LINUX/.wine/drive_c/dev/java/jre/lib && zip -ur rt.jar sun

