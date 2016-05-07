# PM-Installer (Unix)
Auto fetch PocketMine-MP project files from Github and install it's dependencies (PHP binary, submodules)

Note: This script is for Linux/MacOS users only (Windows isn't supported)

To run script 'cd' into directory where you downloaded it and execute
[code]
~ $ sudo bash ./pmInstall.sh

# Or

~ $ sudo chmod +x ./pmInstall.sh
~ $ ./pmInstall.sh
[/code]

If everything went fine, you should see something like
[code]
[INFO] Starting...
[INFO] Script running on Linux x86
[INFO] Checking connectivity...
[INFO] Connected
[INFO] 'git' command found.
[INFO] 'tar' command found.
[INFO] Downloading project files...
# Git clone log messages
[INFO] Project files downloaded
[INFO] Downloading PHP binaries...
# wget log messages
[INFO] PHP binaries extracted
[INFO] Starting PocketMine-MP...

[*] PocketMine-MP set-up wizard
# ...

[/code]
Script will run PocketMine-MP automatically.
