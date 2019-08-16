# linuxTweaks

#Cyberoam Linux Client
sudo apt-get install ia32-libs -> To solve the issue of [bash: ./crclient: No such file or directory] 
ia32-libs -> the repo is obsolete and as been replaced. Copy the new lib ids generated after the result of execution of above command is obtained. [lib32ncurses5 lib32z1]

For correct Java installation: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

Anaconda Permission Denied Error [13]: sudo chown -R user anaconda3, where 'user; is your username

Adjust Linux clock to use local time and use bios time:
$ timedatectl set-local-rtc 1 --adjust-system-clock && timedatectl

Install Card reader drivers: $ sudo apt-get install --reinstall udisks2 and Reboot.

When ubuntu is not able to recognize exfat format: $ sudo apt install exfat-fuse exfat-utils
