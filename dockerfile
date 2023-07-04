FROM openjdk:11-jdk

ARG COMMANDLINE_TOOLS="9477386" \
    BUILD_TOOLS="33.0.2" \
    CMAKE="3.22.1" \
    NDK="22.1.7171670"

ENV ANDROID_SDK_ROOT=/opt/android
ENV ANDROID_NDK_ROOT="/opt/android/ndk/${NDK}"

RUN apt-get update && \
    apt-get install -y file && \
    rm -rf /var/lib/apt/lists/*

RUN    mkdir -p ${ANDROID_SDK_ROOT} \
    && wget --quiet --output-document=${ANDROID_SDK_ROOT}/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${COMMANDLINE_TOOLS}_latest.zip \
    && unzip -qq ${ANDROID_SDK_ROOT}/cmdline-tools.zip -d ${ANDROID_SDK_ROOT} \
    && rm ${ANDROID_SDK_ROOT}/cmdline-tools.zip \
    && mkdir -p $HOME/.android \
    && echo 'count=0' > $HOME/.android/repositories.cfg

ARG SDK_MGR="${ANDROID_SDK_ROOT}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT}"

RUN    yes | ${SDK_MGR} --licenses > /dev/null \ 
    && yes | ${SDK_MGR} --update \
    && yes | ${SDK_MGR} "build-tools;${BUILD_TOOLS}" \
    && yes | ${SDK_MGR} "cmake;${CMAKE}" \
    && yes | ${SDK_MGR} "ndk;${NDK}"
