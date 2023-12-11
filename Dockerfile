FROM ubuntu:22.10
RUN apt-get update
RUN echo "y" | apt-get install curl


#android sdk install
RUN apt-get install android-sdk -y
ENV ANDROID_HOME /usr/lib/android-sdk/

#install cmdline tools
# https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN mkdir temp
RUN cd temp
RUN curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN mkdir $ANDROID_HOME/cmdline-tools
RUN unzip commandlinetools.zip -d unzipped
RUN mv unzipped/cmdline-tools/  $ANDROID_HOME/cmdline-tools/latest/

# install licences
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

#predownloading of all required packages for faster build times

# ndk gets out of date with each update of eas-cli so putting it in the image doesn't make sense
# all requirements below get downloaded by the build process automatically anyway
# RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "ndk;21.4.7075529"
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;30.0.3"
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "cmake;3.18.1"
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "platforms;android-31"

#setup npm
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v18.14.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/bin
ENV PATH $NODE_PATH:$PATH

#eas install
RUN apt-get install git -y
RUN npm i -g eas-cli
RUN npm i -g sharp-cli
RUN npm i -g yarn
RUN npm i -g expo-cli

# set artifacts to /out
RUN mkdir /out
ENV EAS_LOCAL_BUILD_ARTIFACTS_DIR /out
