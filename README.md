# PM-Installer (Unix)
Auto fetch PocketMine-MP project files from Github and install it's dependencies (PHP binary, submodules)

>:round_pushpin: Note: 
>This script is for Linux/MacOS users only (Windows isn't supported)


To run script 'cd' into directory where you downloaded it and execute

```sh
$ sudo bash ./pmInstall.sh

# Or
$ sudo chmod +x ./pmInstall.sh
$ ./pmInstall.sh
```

###Avaliable arguments
```php
  -x: "Compile PHP with xdebug enabled"
  -t: "Set cutom PocketMine install directory"
  -i: "Ignore certifications on file download"
  -m: "Update PocketMine if valid installation found"
  -p: "Update PHP"
  -s: "See more details on git operations"
  -d: "Enable script 
```

If everything went fine, you should see something like
```php
[17:28:32] [INFO]: Script running on Linux x86
[17:28:32] [INFO]: Downloading project files...
[17:30:29] [INFO]: Project files downloaded!
[17:30:29] [INFO]: Downloading PHP binaries...
[17:31:05] [INFO]: PHP archive (PHP_7.0.3_x86_Linux.tar.gz) downloaded
[17:31:06] [INFO]: PHP binaries extracted
[17:31:07] [INFO]: Regenerating php.ini...
[17:31:07] [INFO]: php.ini configured
[17:31:07] [INFO]: Starting PocketMine-MP...
[*] PocketMine-MP set-up wizard
# ...
```
Script will run PocketMine-MP automatically if everything went fine.

>Disclaimer:
>This script were made to learn bash scripting.
