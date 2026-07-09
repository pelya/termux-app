#!/bin/sh
# Set path to your Android keystore and your keystore alias here, or put them in your environment
[ -z "$ANDROID_UPLOAD_KEYSTORE_FILE" ] && ANDROID_UPLOAD_KEYSTORE_FILE=$HOME/.android/debug.keystore
[ -z "$ANDROID_UPLOAD_KEYSTORE_ALIAS" ] && ANDROID_UPLOAD_KEYSTORE_ALIAS=androiddebugkey
#PASS="--ks-pass pass:android"
#[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS" ] && PASS="--ks-pass env:ANDROID_UPLOAD_KEYSTORE_PASS"
#[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS_FILE" ] && PASS="--ks-pass file:$ANDROID_UPLOAD_KEYSTORE_PASS_FILE"
PASS="-storepass android"
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS" ] && PASS="-storepass:env ANDROID_UPLOAD_KEYSTORE_PASS"
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS_FILE" ] && PASS="-storepass:file $ANDROID_UPLOAD_KEYSTORE_PASS_FILE"


APPNAME=termux-app
APPVER=`grep -m 1 versionName app/build.gradle | sed 's/versionName//' | tr -d '" '`

rm -rf tmp
mkdir -p tmp
export GRADLE_OPTS="-Djava.io.tmpdir=`pwd`/tmp"

./gradlew signReleaseBundleJarsigner

#cd app/build/outputs/bundle/release || exit 1

# Sign with the new certificate
#apksigner sign --min-sdk-version 26 \
# --ks $ANDROID_UPLOAD_KEYSTORE_FILE $PASS --ks-key-alias $ANDROID_UPLOAD_KEYSTORE_ALIAS \
# app-release.aab || exit 1
#jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore $ANDROID_UPLOAD_KEYSTORE_FILE \
#  $PASS app-release.aab $ANDROID_UPLOAD_KEYSTORE_ALIAS || exit 1
