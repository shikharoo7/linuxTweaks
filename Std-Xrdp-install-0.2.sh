####################################################################
# Script_Name : Std-Xrdp-install-0.2.sh							   #
# Description : Perform an automated standard installation of xrdp #
# on ubuntu 17.10 and later										   #
# Date : Nov 2018												   #
# written by : Shikhar											   #
# Version : 0.2													   #
# History : 0.2 - Added logic to install linux restricted-extras   #
#				- Added logic to extend flatpack from fedora repos #
#				- Added logic to clean after completion			   #
#			0.1 - Added Logic for Ubuntu 17.10 and 18.04 detection #
#               - Updated the polkit section					   #
#               - New formatting and structure  				   #
#           0.0 - Initial Script       							   #
# Disclaimer : Script provided AS IS. Use it at your own risk....  #
####################################################################

echo
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m#   Standard XRDP Installation Script  - Ver 0.2              #\e[0m"
/bin/echo -e "\e[1;36m#   Written by Shikhar - Nov 2018           					#\e[0m"			
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
echo

#---------------------------------------------------#
# Step 0 - Try to Detect Ubuntu Version.... 		#
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Detecting Ubuntu version                  #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

version=$(lsb_release -d | awk -F":" '/Description/ {print $2}') 

if [[ "$version" = *"Ubuntu 17.10"* ]] || [[ "$version" = *"Ubuntu 18.04"* ]];
then
echo
/bin/echo -e "\e[1;32m.... Ubuntu Version :$version\e[0m"
/bin/echo -e "\e[1;32m.... Supported version detected....proceeding\e[0m"

else
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;31mYour system is not running Ubuntu 17.10 Edition.\e[0m"
/bin/echo -e "\e[1;31mThe script has been tested only on Ubuntu 17.10...\e[0m"
/bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
exit
fi

#---------------------------------------------------#
# Step 1 - Install xRDP Software.... 				#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing XRDP Packages...Proceeding...  #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install xrdp -y 

#----------------------------------------------------#
# Step 2 - Install Gnome Tweak Tool and other extras.# 
#----------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing Gnome Tweak...Proceeding...    #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install gnome-tweak-tool -y &&
sudo apt install ubuntu-restricted-extras -y &&
sudo apt install libavcodec-extra -y &&
sudo apt install flatpak -y &&
sudo apt install gnome-software-plugin-flatpak -y &&
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#---------------------------------------------------#
# Step 3 - Allow console Access .... 				#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Granting Console Access...Proceeding...   #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#---------------------------------------------------#
# Step 4 - create policies exceptions .... 			#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Creating Polkit File...Proceeding...      #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

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

sudo systemctl enable xrdp
echo

#---------------------------------------------------#
# Step 6 - Cleaning up .... 						#
#---------------------------------------------------#
echo
sudo apt-get autoremove &&
sudo apt-get clean &&
sudo apt-get autoclean

echo

#---------------------------------------------------#
# Credits .... 										#
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m# Installation Completed 												  #\e[0m"
/bin/echo -e "\e[1;36m# Please test your xRDP configuration.... 							  #\e[0m"
/bin/echo -e "\e[1;36m# Written by Shikhar - Nov 2018 - Ver 0.2 - Std-Xrdp-Install-0.2.sh     #\e[0m"
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
echo


