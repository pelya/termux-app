#!/usr/bin/python

from tempfile import mkstemp
from shutil import move, copymode
from os import fdopen, remove
import re

NUM_PKGS = 1

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
