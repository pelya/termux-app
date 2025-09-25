#!/bin/sh

rm -rf tmp
mkdir -p tmp
export GRADLE_OPTS="-Djava.io.tmpdir=`pwd`/tmp"

./gradlew --stop
./gradlew publishReleaseBundle 2>&1 | tee publishBundle.log
