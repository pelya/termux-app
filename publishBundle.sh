#!/bin/sh

APPNAME=termux-app
APPVER=`grep -m 1 versionName app/build.gradle | sed 's/versionName//' | tr -d '" '`

./gradlew publishReleaseBundle
