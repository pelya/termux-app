#!/usr/bin/python

from tempfile import mkstemp
from shutil import move, copymode, copytree, rmtree
from os import fdopen, remove, makedirs
import re

NUM_PKGS = 127
TOTAL_SIZE = 5000

def replace(file_path, pattern, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                if pattern.match(line):
                    new_file.write(subst)
                else:
                    new_file.write(line)
    #Copy the file permissions from the old file to the new file
    copymode(file_path, abs_path)
    #Remove original file
    remove(file_path)
    #Move new file
    move(abs_path, file_path)

app = '    dynamicFeatures = ['

for i in range(1, NUM_PKGS + 1):
	app += f'":packages:pkg{i}"'
	if i < NUM_PKGS:
		app += ', '

app += ']\n'

print(app)
replace('app/build.gradle', re.compile(r' *dynamicFeatures =.*'), app)

strs = ""

for i in range(1, NUM_PKGS + 1):
	strs += f'    <string name="packages_pkg{i}">pkg{i}</string>\n'

strs += "</resources>\n"

print(strs)

replace('app/src/main/res/values/strings.xml', re.compile(r' *<string name="packages_.*'), "")
replace('app/src/main/res/values/strings.xml', re.compile(r'</resources>.*'), strs)

inc = ''
for i in range(1, NUM_PKGS + 1):
	inc += f"include ':packages:pkg{i}'\n"

print(inc)
replace('settings.gradle', re.compile(r"include ':packages:.*"), '')
with open('settings.gradle', 'ab') as settings:
	settings.write(inc.encode('utf-8'))

urandom = open('/dev/urandom', 'rb')

for i in range(1, NUM_PKGS + 1):
	rmtree(f'packages/pkg{i}', ignore_errors=True)
	copytree('packages/pkg-template', f'packages/pkg{i}')
	replace(f'packages/pkg{i}/build.gradle', re.compile(r' *namespace .*'),
		f'    namespace "greater.underscore.pkg{i}"\n')
	replace(f'packages/pkg{i}/src/main/AndroidManifest.xml', re.compile(r' *dist:title=.*'),
		f'        dist:title="@string/packages_pkg{i}"\n')
	print(f'pkg{i}')
	for arch in ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64']:
		makedirs(f'packages/pkg{i}/exe/{arch}', exist_ok=True)
		genlib = open(f'packages/pkg{i}/exe/{arch}/libpkg{i}-placeholder.so', 'wb')
		genlib.write(urandom.read(32))
		genlib.close()
	for arch in ['arm64-v8a']:
		for ii in range(TOTAL_SIZE // NUM_PKGS):
			genlib = open(f'packages/pkg{i}/exe/{arch}/libpkg{i}-{ii}.so', 'wb')
			genlib.write(urandom.read(1024 * 1024))
			genlib.close()

urandom.close()
