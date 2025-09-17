#!/bin/sh
# Set path to your Android keystore and your keystore alias here, or put them in your environment
[ -z "$ANDROID_UPLOAD_KEYSTORE_FILE" ] && ANDROID_UPLOAD_KEYSTORE_FILE=$HOME/.android/debug.keystore
[ -z "$ANDROID_UPLOAD_KEYSTORE_ALIAS" ] && ANDROID_UPLOAD_KEYSTORE_ALIAS=androiddebugkey
PASS="--ks-pass pass:android"
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS" ] && PASS="--ks-pass env:ANDROID_UPLOAD_KEYSTORE_PASS"
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS_FILE" ] && PASS="--ks-pass file:$ANDROID_UPLOAD_KEYSTORE_PASS_FILE"

APPNAME=termux-app
APPVER=`grep -m 1 versionName app/build.gradle | sed 's/versionName//' | tr -d '" '`

./gradlew bundleReleaseWithDebugInfo || exit 1

cd app/build/outputs/bundle/releaseWithDebugInfo || exit 1

# Remove old certificate
cp -f app-releaseWithDebugInfo.aab ../../../../../$APPNAME-$APPVER.aab || exit 1
# Sign with the new certificate
echo Using keystore $ANDROID_UPLOAD_KEYSTORE_FILE
#jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $ANDROID_UPLOAD_KEYSTORE_FILE $PASS ../../../../../$APPNAME-$APPVER.aab $ANDROID_UPLOAD_KEYSTORE_ALIAS || exit 1
apksigner sign --min-sdk-version 26 \
 --ks $ANDROID_UPLOAD_KEYSTORE_FILE $PASS --ks-key-alias $ANDROID_UPLOAD_KEYSTORE_ALIAS \
 ../../../../../$APPNAME-$APPVER.aab  || exit 1
