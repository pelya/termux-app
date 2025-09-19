#!/bin/sh

ARCH_LIST="aarch64 arm i686 x86_64"
EXE_DIR="/data/data/greater.underscore/exe"

for ARCH in $ARCH_LIST; do

	NDK_ARCH=$ARCH
	if [ "$ARCH" = "arm" ]; then
		NDK_ARCH=armeabi-v7a
	fi
	if [ "$ARCH" = "aarch64" ]; then
		NDK_ARCH=arm64-v8a
	fi
	if [ "$ARCH" = "i686" ]; then
		NDK_ARCH=x86
	fi

	if [ -e "bootstrap-noexe-$ARCH.zip" -a "bootstrap-noexe-$ARCH.zip" -nt "bootstrap-$ARCH.zip" ]; then
		echo "Executables already extracted from bootstrap-$ARCH.zip"
		continue
	fi

	echo "Extracting executables: bootstrap-$ARCH.zip → exe/$NDK_ARCH bootstrap-noexe-$ARCH.zip"

	rm -rf exe/$NDK_ARCH usr EXECUTABLES-$NDK_ARCH.txt
	mkdir -p exe/$NDK_ARCH usr
	cd usr
	unzip -q ../bootstrap-$ARCH.zip || exit 1

	COUNTER=0

	find . -type f -perm -u+x | sort | while read FILE; do
		mv "$FILE" ../exe/$NDK_ARCH/lib$COUNTER.so
		echo "$EXE_DIR/lib$COUNTER.so←$FILE" >> SYMLINKS.txt
		echo "$COUNTER $FILE" >> ../EXECUTABLES-$NDK_ARCH.txt
		COUNTER=`expr $COUNTER '+' 1`
	done

	COUNTER=`cat ../EXECUTABLES-$NDK_ARCH.txt | wc -l`

	find . -type f | sort | while read FILE; do
		if file "$FILE" | grep "ELF " >/dev/null; then
			mv "$FILE" ../exe/$NDK_ARCH/lib$COUNTER.so
			echo "$EXE_DIR/lib$COUNTER.so←$FILE" >> SYMLINKS.txt
			echo "$COUNTER $FILE" >> ../EXECUTABLES-$NDK_ARCH.txt
			COUNTER=`expr $COUNTER '+' 1`
		fi
	done

	#mv -f ../EXECUTABLES-$NDK_ARCH.txt EXECUTABLES.txt

	zip -q -r ../bootstrap-noexe-$ARCH.zip .
	cp -f ../bootstrap-noexe-$ARCH.zip ../exe/$NDK_ARCH/libtermux-bootstrap.so
	cd ..
done

rm -rf usr
