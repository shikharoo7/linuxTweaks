#!/bin/bash

# Script to download and install missing Intel kernel driver
# Made by Jiab77 / 2020

[[ $# -eq 0 ]] && echo -e "\nUsage: $0 <missing-driver-name>\n" && exit 1

MISSING_DRIVER=$1
BLUE="\033[1;34m"
NC="\033[0m"
NL="\n"

echo -e "${NL}${BLUE}Downloading missing driver...${NC}${NL}"
wget "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/${MISSING_DRIVER}"

echo -e "${NL}${BLUE}Installing downloaded driver...${NC}${NL}"
sudo mv -v $MISSING_DRIVER /lib/firmware/i915/

echo -e "${NL}${BLUE}Updating all kernels...${NC}${NL}"
sudo update-initramfs -u -k all

echo -e "${NL}${BLUE}Finished.${NC}${NL}"
