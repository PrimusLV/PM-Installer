#!/usr/bin/env bash

# PocketMine auto repository fetch script by Primus
#
# Script require 'git' to be installed

GRAY="\e[37m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[97m"
DIM="\e[22m"

TARGET_DIR="PocketMine-MP"
PROJECT_GIT="https://github.com/PocketMine/PocketMine-MP.git"

# PHP Binaries
PHP_BIN_LINUX_86="PHP_7.0.3_x86_Linux.tar.gz"


# TODO: Make checks for os and system
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
if [[ $unamestr == darwin* ]]; then
	PLATFORM="MacOS"
else
	PLATFORM="Linux"
fi

PHP_BIN="PHP_7.0.3_${MACHINE_ARCH}_${PLATFORM}.tar.gz"



# Internal functions below

	# Logger
function Logger.info () {
	echo -e "${DIM}${GRAY}[INFO]${RESET} ${1}"
}
function Logger.warning () {
	echo -e "${DIM}${YELLOW}[WARNING]${RESET} ${1}"
}
function Logger.critical () {
	echo -e "${DIM}${RED}[CRITICAL]${RESET} ${1}"
}

function PocketMine.start () {
	if [ -f "./start.sh" ]; then
		exec "./start.sh ${1}"
	else
		cd $TARGET_DIR
	fi
		exec "./start.sh ${1}"
}

function quit () {
	if [ -z ${1+x} ]; then
		exit
	else
		Logger.info "Code stopped with message: ${1}"
	fi

	exit
}

# Script below

Logger.info "Starting..."

Logger.info "Script running on ${PLATFORM} ${MACHINE_ARCH}"


Logger.info "Checking connectivity..."
	if  ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null; then
		Logger.info "Connected"
	else
		quit "You're working offline. For script to work it must use internet connection."
	fi

	# Check if git is installed
if hash git 2>/dev/null; then
	Logger.info "'git' command found."	
else
	quit "Command 'git' not found. Install package doing ${YELLOW}'sudo apt-get install git'${RESET}"
fi
	# Check if tar is installed
if hash tar 2>/dev/null; then
	Logger.info "'tar' command found."
else
	quit "Command 'tar' not found. Install package doing ${YELLOW}'sudo apt-get install tar'${RESET}"
fi




if [ -e $TARGET_DIR ]; then # TODO: Add --force option and --tar
	if [ -f "${TARGET_DIR}/start.sh" ]; then
		PocketMine.start
	fi
	quit "Target directory '${TARGET_DIR}' already exists."
fi

Logger.info "Downloading project files..."

# Download 
git clone --recursive $PROJECT_GIT $TARGET_DIR

Logger.info "Project files downloaded"

if [ -e $TARGET_DIR ]; then
	cd $TARGET_DIR
else
	Logger.critical "Failed to download project files"
fi

Logger.info "Downloading PHP binaries..."


if [ -f $PHP_BIN ]; then
	Logger.warning "Existing PHP binary archive found. Deleting..."
	rm $PHP_BIN
fi

if [ -f "bin/php7/bin/php" ]; then

	Logger.info "Existing PHP binary found. Skipping..."

else

	wget "https://bintray.com/pocketmine/PocketMine/download_file?file_path=${PHP_BIN}"

	# Rename :P
	mv "download_file?file_path=${PHP_BIN}" "${PHP_BIN}"

	if [ -f $PHP_BIN ]; then 
		# Unzip
		tar -xf $PHP_BIN
		if [ -f "bin/php7/bin/php" ]; then
			Logger.info "PHP binaries extracted"
		else
			quit "Failed to extract PHP binaries"
		fi

	else
		quit "Failed to download PHP binaries"
	fi

fi

#quit ""# END
Logger.info "Starting PocketMine-MP..."
exec "./start.sh"

Logger.info "Done"




