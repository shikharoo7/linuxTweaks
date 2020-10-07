# linuxTweaks

* Follow this guide to start with linux tweaks: https://averagelinuxuser.com/30-things-to-do-after-installing-ubuntu-18-04-lts/

* For correct Java installation: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

* To disable certain peripheral installation: https://phpocean.com/tutorials/computer-skills/how-to-disable-the-touchscreen-drivers-permanently-on-ubuntu-17-10/63

* To install Microsoft PowerShell Tools: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7

* To install Miniconda3: https://varhowto.com/install-miniconda-ubuntu-20-04/

* To Install nVIDIA-Optimus Tools: https://www.omgubuntu.co.uk/2019/09/nvidia-optimus-linux-switching-applet

* To fix firmware errors for rtl8125a-3.fw and rtl8168fp-3.fw: http://forums.debian.net/viewtopic.php?f=5&t=146342

* Initial Install command to setup new system
```bash
sudo apt-get install ubuntu-restricted-extras vlc gnome tweaks chrome-gnome-shell firefox-gnome-shell rar unrar p7zip-full p7zip-rar wine winetricks build-essential
```

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

* When you encounter missing firmware errors, install debian-installer:
```bash
sudo apt-get install debian-installer
```

* Anaconda Permission Denied Error [13]:
```bash
sudo chown -R user anaconda3
```
-> where 'user' is your username

# Cyberoam Linux Client

* To solve the issue of [bash: ./crclient: No such file or directory] even when the file is inside the directory
```bash
sudo apt-get install ia32-libs
```
If the above command returns ia32-libs -> the repo is obsolete and as been replaced, copy the new lib ids generated after the result of execution of above command is obtained [lib32ncurses5 lib32z1] or run the command mentioned below:
```bash
sudo apt-get install lib32ncurses5 lib32z1
```

* To enable partner repositories in Ubuntu (Command Line Way):

1. Open the sources.list file with the command line editor of your choice, ```sudo nano /etc/apt/sources.list``` would use nano on the command line without a GUI.
2. Add the partner repositories by removing the # in front of the following lines (focal is the version of your Ubuntu installation, it may differ, so use the codename of the release you are using instead of 'focal'. If you're not sure run ```lsb_release -c``` to find out.)
```bash
# deb http://archive.canonical.com/ubuntu focal partner
# deb-src http://archive.canonical.com/ubuntu focal partner
```

* If you see a missing firmware warning while execution of an update command, like this:
```bash
W: Possible missing firmware /lib/firmware/i915/tgl_dmc_ver2_04.bin for module i915
W: Possible missing firmware /lib/firmware/i915/skl_guc_33.0.0.bin for module i915
W: Possible missing firmware /lib/firmware/i915/bxt_guc_33.0.0.bin for module i915
W: Possible missing firmware /lib/firmware/i915/kbl_guc_33.0.0.bin for module i915
W: Possible missing firmware /lib/firmware/i915/glk_guc_33.0.0.bin for module i915
W: Possible missing firmware /lib/firmware/i915/kbl_guc_33.0.0.bin for module i915
W: Possible missing firmware /lib/firmware/i915/icl_guc_33.0.0.bin for module i915
```
then, use the included ```install_missing_intel_linux_firmware_driver.sh``` file to download each firmware definition.

Download the script, and make it executable:
```bash
chmod +x install_missing_intel_linux_firmware_driver.sh
```
and then use the scrit as:
```bash
sudo ./install_missing_intel_linux_firmware_driver.sh <firmware_name>
```
where ```<firmware_name>``` is replaced with the string like ```tgl_dmc_ver2_04.bin```.
This method only works for ```i915``` drivers.
