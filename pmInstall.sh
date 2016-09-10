#!/usr/bin/env bash

# PocketMine auto repository fetch script by Primus
#
# Script require 'git' to be installed

TARGET_DIR="PocketMine-MP Server"
PROJECT_GIT="https://github.com/PocketMine/PocketMine-MP.git"

# PHP Binaries
PHP_BIN=false

MACHINE_ARCH=`uname -m`
PLATFORM="unknown"

if [ ${MACHINE_ARCH} == 'x86_64' ]; then
  # 64-bit stuff here
  MACHINE_ARCH="x86-64" # Change format
else
  MACHINE_ARCH="x86"
  # 32-bit stuff here
fi

unamestr=`uname`
if [[ $unamestr == Darwin* ]]; then
	PLATFORM="MacOS"
else
	PLATFORM="Linux"
fi

PHP_BIN="PHP_7.0.3_${MACHINE_ARCH}_${PLATFORM}.tar.gz"

# Settings
XDEBUG="off" # Enable xdebug? -x
DEBUG="off"
IGNORE_CERT="yes"
UPDATE_PM="yes"
UPDATE_PHP="no"
SILENT_GIT="yes"

alldone="no"

# Colors
FORMAT_BOLD="\x1b[1m";
FORMAT_OBFUSCATED="";
FORMAT_ITALIC="\x1b[3m";
FORMAT_UNDERLINE="\x1b[4m";
FORMAT_STRIKETHROUGH="\x1b[9m";
FORMAT_RESET="\x1b[m";
COLOR_BLACK="\x1b[38;5;16m";
COLOR_DARK_BLUE="\x1b[38;5;19m";
COLOR_DARK_GREEN="\x1b[38;5;34m";
COLOR_DARK_AQUA="\x1b[38;5;37m";
COLOR_DARK_RED="\x1b[38;5;124m";
COLOR_PURPLE="\x1b[38;5;127m";
COLOR_GOLD="\x1b[38;5;214m";
COLOR_GRAY="\x1b[38;5;145m";
COLOR_DARK_GRAY="\x1b[38;5;59m";
COLOR_BLUE="\x1b[38;5;63m";
COLOR_GREEN="\x1b[38;5;83m";
COLOR_AQUA="\x1b[38;5;87m";
COLOR_RED="\x1b[38;5;203m";
COLOR_LIGHT_PURPLE="\x1b[38;5;207m";
COLOR_YELLOW="\x1b[38;5;227m";
COLOR_WHITE="\x1b[38;5;231m";

# Internal functions below

	# Logger
function Logger.info () { send "$COLOR_WHITE[INFO]: ${1}"; }
function Logger.warning () { send "$COLOR_YELLOW[WARNING]: ${1}"; }
function Logger.critical () { send "$COLOR_RED[CRITICAL]: ${1}"; }
function Logger.debug () { if [ $DEBUG == "on" ]; then send "$COLOR_GRAY[DEBUG]: ${1}"; fi }
function PocketMine.start () { if [ -f "./start.sh" ]; then exec "./start.sh"; else cd "$TARGET_DIR"; fi; exec "./start.sh"; }
function send () { echo -e "$COLOR_DARK_AQUA[$(date +%H:%M:%S)] ${1}"; }
function quit () {
	if [ -z ${1+x} ]; then
		exit
	else
		Logger.info "exit: ${1}"
	fi

	exit
}

while getopts "xdiupsm:v:t:" opt; do
  case $opt in
x)
	XDEBUG="on"
	Logger.info "Enabled xdebug"
	;;
d)	DEBUG="on"
	Logger.debug "Script debug enabled"
	;;
t)
	TARGET_DIR="$OPTARG"
	;;
i)
	IGNORE_CERT="no"
	;;
m)
	UPDATE_PM="no"
	Logger.info "Script won't update PocketMine due to user request"
	;;
p)
	UPDATE_PHP="yes"
	Logger.info "Script will update PHP library"
	;;
s)
	SILENT_GIT="no"
	Logger.info "Git clone operations will be visible now"
	;;
\?)
	Logger.warning "Invalid option: -$OPTARG" >&2
	quit
	;;
  esac
done

# Script below
Logger.info "Script running on ${PLATFORM} ${MACHINE_ARCH}"

# If debug is enabled then "silent git" operations are not possible
if [ "$DEBUG" == "on" ] && [ "$SILENT_GIT" == "no" ]; then
	SILENT_GIT="yes"
fi

Logger.debug "Checking connectivity..."
	if  ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null; then
		Logger.debug "Connected"
	else
		quit "You're working offline. For script to work it must use internet connection."
	fi

	# Check if git is installed
if hash git 2>/dev/null; then
	Logger.debug "git required."	
else
	quit "Script requires 'git'. Install package doing 'sudo apt-get install git'"
fi
	# Check if tar is installed
if hash tar 2>/dev/null; then
	Logger.debug "tar required."
else
	quit "Script requires 'tar'. Install package doing 'sudo apt-get install tar'"
fi

#Needed to use aliases
shopt -s expand_aliases
type wget > /dev/null 2>&1
if [ $? -eq 0 ]; then
	if [ "$IGNORE_CERT" == "yes" ]; then
		alias download_file="wget --no-check-certificate -q "
	else
		alias download_file="wget -q -O "
	fi
else
	type curl >> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		if [ "$IGNORE_CERT" == "yes" ]; then
			alias download_file="curl --insecure --silent --location"
		else
			alias download_file="curl --silent --location"
		fi
	else
		quit "curl or wget not found"
	fi
fi

if [ "$SILENT_GIT" == "yes" ]; then
	alias pm_fetch="git pull --quiet"
	alias pm_clone="git clone --recursive --quiet"
else
	alias pm_fetch="git pull";
	alias pm_clone="git clone --recursive"
fi



if [ -e "$TARGET_DIR/.git" ]; then # TODO: Add --force option and --tar

	if [ $UPDATE_PM == "yes" ]; then
		Logger.info "PocketMine found. Updating..."
		cd "$TARGET_DIR"
		pm_fetch
	else
		Logger.info "PocketMine found."
	fi

else

	Logger.info "Downloading project files..."

	# Download 
	pm_clone --recursive "$PROJECT_GIT" "$TARGET_DIR"

	Logger.info "Project files downloaded"

	if [ -e "$TARGET_DIR" ]; then
		cd "$TARGET_DIR"
	else
		Logger.critical "Failed to download project files"
	fi

fi

if [ $UPDATE_PHP == "yes" ]; then
	if [ -e "bin" ]; then
		rm -r "bin"
		 fi
fi

if [ -f $PHP_BIN ]; then
	Logger.warning "Existing PHP binary archive found. Deleting..."
	rm $PHP_BIN
fi

Logger.info "Downloading PHP binaries..."

if [ -f "bin/php7/bin/php" ]; then

	Logger.info "Existing PHP binary found. Skipping..."

else

	download_file "https://dl.bintray.com/pocketmine/PocketMine/${PHP_BIN}"

	if [ -f $PHP_BIN ]; then 
		Logger.info "PHP archive (${PHP_BIN}) downloaded"
		# Unzip
		tar -xf $PHP_BIN

		rm $PHP_BIN # Delete the file after extraction
		
		if [ -f "bin/php7/bin/php" ]; then
			Logger.info "PHP binaries extracted"
		else
			quit "Failed to extract PHP binaries"
		fi

		Logger.debug "Setting permissions"
		chmod +x ./bin/php7/bin/*
		chmod +x ./start.sh
		chmod +x ./start.cmd

	else
		quit "Failed to download PHP binaries"
	fi

fi

# Code block from: https://raw.githubusercontent.com/PocketMine/php-build-scripts/master/installer.sh (by PocketMine team)
if [ "$(./bin/php7/bin/php -r 'echo 1;' 2>/dev/null)" == "1" ]; then
				Logger.info "Regenerating php.ini..."
				TIMEZONE=$(date +%Z)
				#OPCACHE_PATH="$(find $(pwd) -name opcache.so)"
				XDEBUG_PATH="$(find "$(pwd)" -name xdebug.so)"
				echo "" > "./bin/php7/bin/php.ini"
				if [ "$XDEBUG" == "on" ]; then
					echo "zend_extension=\"$XDEBUG_PATH\"" >> "./bin/php7/bin/php.ini"
				fi
				echo "opcache.enable=1" >> "./bin/php7/bin/php.ini"
				echo "opcache.enable_cli=1" >> "./bin/php7/bin/php.ini"
				echo "opcache.save_comments=1" >> "./bin/php7/bin/php.ini"
				echo "opcache.load_comments=1" >> "./bin/php7/bin/php.ini"
				echo "opcache.fast_shutdown=0" >> "./bin/php7/bin/php.ini"
				echo "opcache.max_accelerated_files=4096" >> "./bin/php7/bin/php.ini"
				echo "opcache.interned_strings_buffer=8" >> "./bin/php7/bin/php.ini"
				echo "opcache.memory_consumption=128" >> "./bin/php7/bin/php.ini"
				echo "opcache.optimization_level=0xffffffff" >> "./bin/php7/bin/php.ini"
				echo "date.timezone=$TIMEZONE" >> "./bin/php7/bin/php.ini"
				echo "short_open_tag=0" >> "./bin/php7/bin/php.ini"
				echo "asp_tags=0" >> "./bin/php7/bin/php.ini"
				echo "phar.readonly=0" >> "./bin/php7/bin/php.ini"
				echo "phar.require_hash=1" >> "./bin/php7/bin/php.ini"
				echo "zend.assertions=-1" >> "./bin/php7/bin/php.ini"
				Logger.info "php.ini configured"
				alldone=yes
			else
				echo " invalid build detected"
			fi

if [ $alldone == "no" ]; then
	Logger.warning "Failed to get PHP build from bintray"
	Logger.warning "Script will now try to get & run compile.sh to compile PHP automatically"
	download_file "https://raw.githubusercontent.com/PocketMine/php-build-scripts/${BRANCH}/compile.sh" > compile.sh
	if [ -f compile.sh ]; then
		chmod +x ./compile.sh
		exec ./compile.sh
	else
		Logger.critical "Failed to get compile.sh script. PocketMine got no PHP build to. Try to install PHP manually."
		quit
	fi
fi

Logger.info "Starting PocketMine-MP..."

PocketMine.start

Logger.info "Done"
