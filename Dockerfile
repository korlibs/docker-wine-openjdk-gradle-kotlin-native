FROM ubuntu:18.10
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

# Used environment variables
ENV DEBIAN_FRONTEND=noninteractive \
	WINEPREFIX=/home/user/.wine \
	WINEDEBUG=-all \
	JAVA_HOME_WINE=/home/user/.wine/drive_c/dev/java \
	USER_HOME_LINUX=/home/user \
	USER_HOME_WINE=/home/user/.wine/drive_c/users/user

# Download all the required dependencies as root and create "user"
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --no-install-recommends openjdk-8-jdk-headless unzip wget curl nano libtinfo-dev libtinfo5 wine wine32 wine64 zip && \
	chmod 0777 -R /usr/local/bin && \
	useradd -ms /bin/bash user && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Switch from root to user
USER user

ADD --chown=user java/nio/file/Files.java /tmp/java/nio/file/Files.java

RUN echo Start && \
	# Initialize wine for user && \
	# Add gradle-win and winecmd tools && \
	wine wineboot --init && \
	cd /usr/local/bin && \
	echo "#!/bin/bash\nwine cmd /c gradle \$*" > gradle-win && \
	echo "#!/bin/bash\nwine cmd /c \$*" > winecmd && \
	chmod +x gradle-win winecmd && \
	# Download openjdk8 && \
	# Patches openjdk8 RT java.nio.file.Files to circumvent the docker+wine+java bug/problem. Check java/nio/file/README.md for details. && \
	mkdir -p $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	cd $USER_HOME_LINUX/.wine/drive_c/dev/ && \
	wget --quiet https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.191-1/java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	unzip java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	rm -f java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64.zip && \
	mv java-1.8.0-openjdk-1.8.0.191-1.b12.ojdkbuild.windows.x86_64 java && \
	rm java/src.zip && \
	cd $JAVA_HOME_WINE/jre/lib && \
	mkdir -p $JAVA_HOME_WINE/jre/lib/java/nio/file && \
	cp /tmp/java/nio/file/Files.java $JAVA_HOME_WINE/jre/lib/java/nio/file/Files.java && \
	javac -XDignore.symbol.file java/nio/file/Files.java && \
	jar uf rt.jar java && \
	rm -rf java && \
	# Set JAVA_HOME and PATH environment variables with gradle and java, and wait wineserver for 5 seconds to flush files && \
	cd $USER_HOME_LINUX && \
	export WINE_PATH="C:\\windows\\system32;C:\\windows;C:\\windows\\system32\\wbem;C:\\dev\\gradle\\bin;C:\\dev\\java\\bin" && \
	wine reg add "HKEY_CURRENT_USER\\Environment" /v JAVA_HOME /t REG_SZ /d c:\\dev\\java && \
	wine reg add "HKEY_CURRENT_USER\\Environment" /v PATH /t REG_SZ /d $WINE_PATH && \
	# Create .gradle, .konan and .m2 && \
	mkdir -p $USER_HOME_WINE/.gradle && \
	mkdir -p $USER_HOME_WINE/.konan && \
	mkdir -p $USER_HOME_WINE/.m2 && \
	mkdir -p $USER_HOME_LINUX/.gradle && \
	mkdir -p $USER_HOME_LINUX/.konan && \
	mkdir -p $USER_HOME_LINUX/.m2 && \
	# Wait for wine to finish and flush stuff && \
	wineserver -w && \
	sleep 5

# Volumes for wine, linux and work that will held the work, usually mounted with "-v$PWD:/work"
VOLUME ["$USER_HOME_WINE/.gradle", "$USER_HOME_WINE/.konan", "$USER_HOME_WINE/.m2", "$USER_HOME_LINUX/.gradle", "$USER_HOME_LINUX/.konan", "$USER_HOME_LINUX/.m2", "/work"]

WORKDIR /work
