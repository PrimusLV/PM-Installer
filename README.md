# PM-Installer (Unix)
Auto fetch PocketMine-MP project files from Github and install it's dependencies (PHP binary, submodules)

>:round_pushpin: Note: 
>Note: This script is for Linux/MacOS users only (Windows isn't supported)


To run script 'cd' into directory where you downloaded it and execute

```sh
~ $ sudo bash ./pmInstall.sh

# Or

~ $ sudo chmod +x ./pmInstall.sh
~ $ ./pmInstall.sh
```

###Avaliable arguments
```php
  -x: "Compile PHP with xdebug enabled"
  -t: "Set cutom PocketMine install directory"
  -i: "Ignore certifications on file download"
  -m: "Update PocketMine if valid installation found"
  -p: "Update PHP"
```

If everything went fine, you should see something like
```php
[12:45:03 INFO]: Starting...
[12:45:03 INFO]: Script running on Linux x86
[12:45:03 INFO]: Checking connectivity...
[12:45:03 INFO]: Connected
[12:45:03 DEBUG]: git required.
[12:45:03 DEBUG]: tar required.
[12:45:03 INFO]: Downloading project files...
Cloning into 'PM-Test'...
# Git clone log messages
[12:46:42 INFO]: Project files downloaded
[12:46:42 INFO]: Downloading PHP binaries...
[12:47:17 INFO]: PHP archive (PHP_7.0.3_x86_Linux.tar.gz) downloaded
[12:47:20 INFO]: PHP binaries extracted
[12:47:20 DEBUG]: Setting permissions
[12:47:21 INFO]: Regenerating php.ini...
[12:47:21 INFO]: php.ini configured
[12:47:21 INFO]: Starting PocketMine-MP...
[*] PocketMine-MP set-up wizard
# ...
```
Script will run PocketMine-MP automatically if.

###Disclaimer
This script were made to learn bash scripting.
