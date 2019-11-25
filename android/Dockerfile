FROM soywiz/kotlin-native-win:opengl-openal
MAINTAINER Carlos Ballesteros Velasco <soywiz@gmail.com>

#RUN sudo apt-get -y update && sudo apt-get -y install android-sdk
#RUN sdkmanager "platform-tools" "platforms;android-28"
RUN cd ~ && wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && unzip sdk-tools-linux-4333796.zip && rm sdk-tools-linux-4333796.zip && mkdir android-sdk && mv tools android-sdk/tools
RUN mkdir -p ~/.android/
RUN touch ~/.android/repositories.cfg
ENV PATH="/home/user/android-sdk/tools/bin/:${PATH}"
ENV PATH="/home/user/android-sdk/platform-tools/bin/:${PATH}"
ENV ANDROID_HOME="/home/user/android-sdk"
RUN sdkmanager --update
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools"
RUN sdkmanager "platforms;android-28"
RUN sdkmanager "build-tools;28.0.3"
