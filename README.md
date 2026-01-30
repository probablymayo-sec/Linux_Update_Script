# Linux_Update_Script

This update script is pretty simple and similar to what you would usually run, but this is intended for a Cron-Job. 

Setting this script to run weekly (or however often you would like) would completely eliminate the need to even check for updates. 

After checking for updates and applying them, the system will (if required) restart. 

The results of the script will be loged in a file ```/var/log/weekly-updates.log```
- stdout and stderr are both thrown into this file
  - If you don't want this, then you can just delete this line or comment out ```exec >>/var/log/weekly-updates.log 2>&1```

FYI - You may get an error `bash: ./updateScript.sh: cannot execute: required file not found`. 
- This likely means that the file has Windows line endings (CRLF). Fix it with: `dos2unix updateScript.sh`  

## Setting a Weekly Cron Job

In order to set the cron job, the easiest way to start is to login as root. You could use sudo privs as well but I find using root tmeporarily for this much easier. The reason you need to login as root is because these commands require superuser or root privs in order to run. With that being said, unless your script is being run as root, you will still need to manually type in your user password in order to apply the updates. That would ruin the point of using cron to schedule this unless you plan to run this manually.

In addition to this, running performing this as root is important for security reasons. Here it doesn't do much since your user is part of the sudoers group (elevated privs) but in a lot of environments, restricting file interactions by only giving read / write and ownership to the root account will prevent anyone from editing the script if they gain access to a lower level users credentials. If a normal user without sudo privs was allowed to edit a weekly cron job that ran with root priveleges, then they could effectively change the script to be able to do anything they want.

- login as root with ```sudo su```

Give the file execute privileges with   ```chmod +x updateScript.sh```

Although not necessary, you can change the ownership of the file to root. As mentioned above, this is good general practice: anything executed by root on a schedule should not be modifiable by non-root users.
- do this with ```chown root:root updateScript.sh```

### Option 1

This option is easiest to "apply and forget" about the script. Use option 2 if you want more control over the exact time/day that the script runs.

You're going to copy the file into **/etc/cron.weekly**. On Debian/Kali, anything executable in **/etc/cron.weekly/** will run automatically. Copy the file into the directory with: 
- ```mv updateScript.sh /etc/cron.weekly/updateScript.sh```
  - I re-named the update script it weekly-update but you can name it whatever you want

And you're all done

### Option 2

Use this option if you want complete control over the exact time and day that the script runs 

You're going to move the script to the /usr/local/bin directory. This is the best place to keep the script for several reasons like preventing overwrites, organization etc. according the the Linux Filesystem Heirarchy Standard (FHS). 
- ```mv updateScript /usr/local/bin```

Now you need to edit the crontab to schedule the task. In my example below I scheduled my task to run every week at 5:00am. The crontab file includes a similar example as well as more information on how to set the crontab. 
- Open crontab with `crontab -e`

The file will be full of comments. You'll edit the file by appending to the end of it with something like this: 
- `0 5 * * 1 /usr/local/bin/updateScript.sh`

If you're using nano you can save with **Ctrl + O, Enter** and then exit with **Ctrl + X**

All done
