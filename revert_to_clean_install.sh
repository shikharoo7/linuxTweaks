#!/bin/bash
sdiff [your install list] [clean install list] --suppress-common-lines > differences.txt
sdiff [clean install list] [differences] --suppress-common-lines > remove.txt

:%s/install//g

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

sudo apt install dos2unix
dos2unix <filename>