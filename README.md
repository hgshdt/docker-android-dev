# docker-android-dev

Dockerfile of Android Build Tools & NDK. Use only for build.

## Versions

- Build Tools: 33.0.2, 30.0.3
- Platform: android-33
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

Build at Jul 20, 2023.

```console
$ docker run -v ${PWD}:/work --rm -it android-dev /bin/bash
(# npx react-native@0.72.3 init AwesomeProject)
# cd AwesomeProject
(# cd android && ./gradlew clean && cd ..)
# npx react-native@0.72.3 build-android --mode=release
# ls -al android/app/build/outputs/bundle/release/
# cd /work
(# rm app.apks)
# java -jar bundletool.jar build-apks --bundle=AwesomeProject/android/app/build/outputs/bundle/release/app-release.aab \
--output=app.apks \
--ks=AwesomeProject/android/app/my-upload-key.keystore \
--ks-pass=pass:******* \
--ks-key-alias=my-key-alias \
--key-pass=pass:*******
```

```console
$ bundletool get-device-spec --output=spec.json
$ mkdir apks
$ bundletool extract-apks --apks=app.apks \
--output-dir=apks \
--device-spec=spec.json
$ cd apks
$ adb install-multiple base-arm64_v8a_2.apk base-en.apk base-master_2.apk bundle-xhdpi.apk
```

__MEMO__

```console
# apt-get update
# apt-get install vim
# cd /work
# wget https://github.com/google/bundletool/releases/download/1.15.2/bundletool-all-1.15.2.jar -O bundletool.jar
```

```console
# cd AwesomeProject/android/app
# keytool -genkey -v -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

Edit `android/gradle.properties`

```
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=*******
MYAPP_UPLOAD_KEY_PASSWORD=*******
```

Edit `android/app/build.gradle`

```
android {
    ...
    defaultConfig { ... }
    signingConfigs {
        release {
            if (project.hasProperty('MYAPP_UPLOAD_STORE_FILE')) {
                storeFile file(MYAPP_UPLOAD_STORE_FILE)
                storePassword MYAPP_UPLOAD_STORE_PASSWORD
                keyAlias MYAPP_UPLOAD_KEY_ALIAS
                keyPassword MYAPP_UPLOAD_KEY_PASSWORD
            }
        }
    }
    buildTypes {
        release {
            ...
            signingConfig signingConfigs.release
        }
    }
}
```
