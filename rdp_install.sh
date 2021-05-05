#!/bin/bash

echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing XRDP Packages...Proceeding...  #\e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

desktop=$(ls -l /usr/share/xsessions/ | grep "gnome")

if [ -z "$desktop" ]; then
sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y
fi
sudo apt install xrdp -y &&
sudo systemctl status xrdp &&
sudo adduser xrdp ssl-cert &&
sudo systemctl restart xrdp

echo
/bin/echo -e "\e[1;33m#--------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing Miniconda Packages...Proceeding...  #\e[0m"
/bin/echo -e "\e[1;33m#--------------------------------------------------#\e[0m"
echo

cd $HOME/
mkdir Downloads && cd Downloads &&
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh &&
chmod +x Miniconda3-latest-Linux-x86_64.sh &&
./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda &&

echo Radio@021 | sudo -S printf '%s\n' '# Miniconda Initialization for python' 'source ~/miniconda3/etc/profile.d/conda.sh' 'if [[ -z ${CONDA_PREFIX+x} ]]; then' '    export PATH="~/conda/bin:$PATH"' 'fi' >> ~/.bashrc &&
source ~/.bashrc


#!/bin/bash
unset password
prompt="Enter Password:"
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
        break
    fi
    prompt='*'
    password+="$char"
done
echo
echo "Done. Password=$password"