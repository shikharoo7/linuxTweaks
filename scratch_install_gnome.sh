#!/bin/bash
#####################################################################
# Script_Name : Std-install-0.5.sh						            #
# Description : Perform an automated standard installation of a     #
# linux machine (Miniconda for python, xRDP for Remote Desktop, and #
# essential packages for development) on ubuntu 17.04 and later	    #
# Date : May 2021												    #
# Written by : Shikhar											    #
# Version : 0.5										                #
# History :                                                         #
#           0.5 - For security, Clear the PASSWORD at execution end #
#               -                                                   #
#           0.4 - Save password for sudo permissions                #
#           0.3 - Added Miniconda installation Script               #
#               - Removed polki script                              #
#           0.2 - Added logic to install linux restricted-extras    #
#				- Added logic to extend flatpack from fedora repos  #
#				- Added logic to clean after completion			    #
#			0.1 - Added Logic for Ubuntu later to 17.04             #
#               - New formatting and structure  				    #
#           0.0 - Initial Script       							    #
# Disclaimer : Script provided AS IS. Use it at your own risk....   #
#####################################################################

# sudo apt install dos2unix
# dos2unix <filename>
# unset PASSWORD &&
# prompt="Enter Password:"
# while IFS= read -p "$prompt" -r -s -n 1 char; do if [[ $char == $'\0' ]]; then break; fi; prompt='*'; PASSWORD+="$char"; done

read -sp "Please enter your password: " PASSWORD
echo "Done. Executing further...."

echo
/bin/echo -e "\e[1;36m#------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m#   Creating Backup....              #\e[0m"
/bin/echo -e "\e[1;36m#------------------------------------#\e[0m"
echo

echo $PASSWORD | sudo -S cp ~/.bashrc ~/.bashrc.bak
dpkg --get-selections > clean_install.txt

echo
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m#   Standard Linux Installation Script - Ver 0.5              #\e[0m"
/bin/echo -e "\e[1;36m#   Written by Shikhar - May 2021           					#\e[0m"
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
echo

#---------------------------------------------------#
# Step 0 - Try to Detect Ubuntu Version.... 		#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!          Detecting Ubuntu version           #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

version=$(lsb_release -r | awk -F":" '/Release/ {print $2}')
id=$(lsb_release -i | awk -F":" '/Distributor ID/ {print $2}')

if [ "`echo "${version} >= 17.04" | bc`" -eq 1 ]; #&& [ $id=="Ubuntu" ];
then
/bin/echo -e "\e[1;32m.... Ubuntu Version :$version\e[0m"
/bin/echo -e "\e[1;32m.... Supported version detected....proceeding\e[0m"

else
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;31mYour system is not running a compatible Ubuntu Edition....\e[0m"
/bin/echo -e "\e[1;31m        ......The script will exit......                  \e[0m"
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
exit
fi

#---------------------------------------------------#
# Step 1 - Update the system.... 				#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Update the system......Proceeding.......  #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

echo $PASSWORD | sudo -S apt update && sudo apt full-upgrade --allow-downgrades -y

#---------------------------------------------------#
# Step 2 - Install xRDP .... 				#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing XRDP Packages...Proceeding...  #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

desktop=$(ls -l /usr/share/xsessions/ | grep "gnome")

if [ -z "$desktop" ]; then
sudo apt install ubuntu-desktop -y
fi
sudo apt install xrdp -y
sudo systemctl status xrdp
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

#------------------------------------------------------#
# Step 2 - Install Gnome Tweak Tool and other extras...# 
#------------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing Gnome Tweak...Proceeding...    #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

desktop=$(ls -l /usr/share/xsessions/ | grep "gnome")

if [ -n "$desktop" ]; then
sudo apt-get install gnome-tweak-tool -y
sudo apt install gnome-software-plugin-flatpak -y
fi
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install ubuntu-restricted-extras -y
sudo apt install libavcodec-extra -y
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#---------------------------------------------------#
# Step 4 - Allow console Access .... 				#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Granting Console Access...Proceeding...   #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

if [ -n "$desktop" ]; then
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#---------------------------------------------------#
# Step 5 - Enable Extensions .... 					#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Install Extensions Dock...Proceeding...   #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo
gnome-shell-extension-tool -e ubuntu-dock@ubuntu.com
gnome-shell-extension-tool -e ubuntu-appindicators@ubuntu.com
fi

#-----------------------------------------------------------------------------#
# Step 6 - Installing Miniconda Packages and Initializing the Environment ....#
#-----------------------------------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#--------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing Miniconda Packages...Proceeding...  #\e[0m"
/bin/echo -e "\e[1;33m#--------------------------------------------------#\e[0m"
echo

cd $HOME/
DIR="Downloads"
if [ ! -d "$DIR" ]; then
  # Take action if $DIR exists. #
  mkdir $DIR
fi
cd Downloads
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
echo $PASSWORD | sudo -S printf '%s\n' '' '# Miniconda Initialization for python' 'source ~/miniconda3/etc/profile.d/conda.sh' 'if [[ -z ${CONDA_PREFIX+x} ]]; then' 'export PATH="~/conda/bin:$PATH"' 'fi' >> ~/.bashrc
#source ~/.bashrc

#---------------------------------------------------#
# Step 7 - Cleaning up .... 						#
#---------------------------------------------------#
echo
#PASSWORD=''
cd $HOME
dpkg --get-selections > installed.txt
sudo apt autoremove -y && sudo apt autoclean -y
echo

#---------------------------------------------------#
# Credits .... 										#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;36m#-------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m# Installation Completed....#\e[0m"
/bin/echo -e "\e[1;36m# Please test your xRDP configuration.... #\e[0m"
/bin/echo -e "\e[1;36m#-------------------------------------------------------#\e[0m"
echo
echo "Please log into the RDP session and Click on 'Use default configuration'. Then execute 'exec bash' manually in the terminal."

