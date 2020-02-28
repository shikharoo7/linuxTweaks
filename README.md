# linuxTweaks

* Follow this guide to start with linux tweaks: https://averagelinuxuser.com/30-things-to-do-after-installing-ubuntu-18-04-lts/

* For correct Java installation: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

* Adjust Linux clock to use local time and use bios time:
```bash
timedatectl set-local-rtc 1 --adjust-system-clock && timedatectl
```

* Install Card reader drivers:
```bash
sudo apt-get install --reinstall udisks2
```
and Reboot.

* When ubuntu does not recognize exfat format:
```bash
sudo apt-get install --reinstall exfat-fuse exfat-utils
```

* Anaconda Permission Denied Error [13]:
```bash
sudo chown -R user anaconda3
```
-> where 'user' is your username

#Cyberoam Linux Client

* To solve the issue of [bash: ./crclient: No such file or directory] even when the file is inside the directory
```bash
sudo apt-get install ia32-libs
```
If the above command returns ia32-libs -> the repo is obsolete and as been replaced, copy the new lib ids generated after the result of execution of above command is obtained [lib32ncurses5 lib32z1] or run the command mentioned below:
```bash
sudo apt-get install lib32ncurses5 lib32z1
```
