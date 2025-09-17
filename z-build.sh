#!/bin/sh

./gradlew assembleDebug || exit 1

[ -n "$1" ] && {
	adb install -r app/build/outputs/apk/debug/termux-app_apt-android-7-debug_arm64-v8a.apk
	#adb shell pm clear greater.underscore
	adb shell am start -n greater.underscore/com.termux.app.TermuxActivity
}
