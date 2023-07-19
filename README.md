# docker-android-dev

Dockerfile of Android Build Tools & NDK. Use only for build.

## Versions

- Build Tools: 33.0.2, 30.0.3
- NDK: 22.1.7171670

## Build

```console
($ docker login)
$ docker build -t android-dev .
```

## Examples

### FFmpegKit v5.1

Build at Jul 4, 2023.

```console
$ git clone git@github.com:arthenica/ffmpeg-kit.git -b v5.1
$ docker run -v ${PWD}/ffmpeg-kit:/ffmpeg-kit --rm -it android-dev /bin/bash
# apt-get update
# apt-get install -y autoconf automake libtool pkg-config curl cmake gcc gperf texinfo yasm nasm bison autogen git wget autopoint meson
# cd /ffmpeg-kit
# git config --global --add safe.directory /ffmpeg-kit
# ./android.sh
# ls -al prebuilt/bundle-android-aar/ffmpeg-kit
# exit
```

```console
$ git clone git@github.com:arthenica/ffmpeg-kit-test.git -b android.v5.1
$ vi ffmpeg-kit-test/android/settings.gradle
$ vi ffmpeg-kit-test/android/test-app-local-dependency/build.gradle
$ docker run -v ${PWD}:/work --rm -it android-dev /bin/bash
# cd /work/ffmpeg-kit-test/android
# ./gradlew assemble
# ls -al test-app-local-dependency/build/outputs/apk/release/
# exit
```

- Change `targetSdk` and `compileSdk` version in `build.gradle`.
- Remove `test-app-maven-central` line in `settings.gradle`.

### OpenSSL v1.1.1u

Build at Jul 4, 2023.

```console
$ git clone git@github.com:leenjewel/openssl_for_ios_and_android.git
$ docker run -v ${PWD}/openssl_for_ios_and_android:/openssl --rm -it android-dev /bin/bash
# apt-get update
# apt-get install -y pkg-config make
# cd /openssl/tools
# export version="1.1.1u"
# sh build-android-openssl-all.sh 2>&1 | tee build.log
# ls -al ../output/android
# exit
```

### React Native App v0.72.3

Build at Jul 19, 2023.

```console
$ docker run -v ${PWD}:/work --rm -it android-dev /bin/bash
# npx react-native@0.72.3 init AwesomeProject
# cd AwesomeProject/android
# ./gradlew bundleRelease
```
