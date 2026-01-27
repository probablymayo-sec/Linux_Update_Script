#!/bin/bash

# This is an update script intended for a cronjob to update weekly, but this can also ofc be run manually

# this will stop the script if any of the commands return a non-zero exit code (fail)
set -e

# Log everything (stdout and stderr) to this file (appends it to the end of the file)
exec >>/var/log/weekly-updates.log 2>&1

apt update -y

# installs the newest packages and will remove existing packages if needed to satisfy / resolve dependencies
apt full-upgrade -y

# removes old package files from local cache. It only removed the package files that can no longer be downloaded (the ones that are versioned out or obselete)
apt autoclean -y 

# removes packages automatically installed as dependencies for other software that isn't needed anymore
apt autoremove -y

# Sometimes a sytem restart is required in order to apply updates that may manipulate the kernel, systemdd, C library or firmware. 
# When a system restart is required, a file will be created (/var/run/reboot-required). 
# If this file exists, this will reboot the system.
if [ -f /var/run/reboot-required ]
then
        /sbin/reboot
fi

       
