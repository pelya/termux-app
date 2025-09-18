#!/bin/sh

./gradlew assembleDebug || exit 1

[ -n "$1" ] && {
	# Set path to your Android keystore and your keystore alias here, or put them in your environment
	[ -z "$ANDROID_KEYSTORE_FILE" ] && ANDROID_KEYSTORE_FILE=$HOME/.android/debug.keystore
	[ -z "$ANDROID_KEYSTORE_ALIAS" ] && ANDROID_KEYSTORE_ALIAS=androiddebugkey
	PASS="--ks-pass pass:android"
	[ -n "$ANDROID_KEYSTORE_PASS" ] && PASS="--ks-pass env:ANDROID_KEYSTORE_PASS"
	[ -n "$ANDROID_KEYSTORE_PASS_FILE" ] && PASS="--ks-pass file:$ANDROID_KEYSTORE_PASS_FILE"

	apksigner sign --min-sdk-version 26 \
		--ks $ANDROID_KEYSTORE_FILE $PASS --ks-key-alias $ANDROID_KEYSTORE_ALIAS \
		/build/outputs/apk/debug/termux-app_apt-android-7-debug_arm64-v8a.apk || exit 1

	adb install -r app/build/outputs/apk/debug/termux-app_apt-android-7-debug_arm64-v8a.apk
	adb shell pm clear greater.underscore
	adb shell am start -n greater.underscore/com.termux.app.TermuxActivity
}
