#!/bin/bash
#
#

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

echo "##################################################### "
echo "######                                         ###### "
echo "######               OS X Setup                ###### "
echo "######                                         ###### "
echo "##################################################### "

sudo -v

echo "How is it going?"
sleep 1
read scriptName
sleep 1

echo " ."
echo " ."

#####################################################
######                Variable                 ######
#####################################################

userName=$(id -un)
fullName=$(id -F)
    arrIN=(${fullName// / })
userDirectory=$(eval echo ~$USER)
zshDirectory=$userDirectory/.zsh

#####################################################
######                Variable                 ######
#####################################################

echo " "
echo "Hello ${arrIN[0]}, ... ${arrIN[1]}? humm."
echo " "
sleep 2
echo "This script will setup your terminal up like the rockstar you are... ${arrIN[0]}!"
echo " "
sleep 2

if [ -d "$userDirectory/$zshDirectory" ]
then
    # echo "Exited with status $?"
    echo "Scripts directory already exist, cd into ~/.zsh/ "
    echo " "
    cd $zshDirectory && ls -al
    sleep 2
else
    `/bin/mkdir -p "$zshDirectory" 2> /dev/null`
    echo " "
    sleep 1
    ls -al $zshDirectory
    sleep 1
    echo ".zsh/ folder created in $userDirectory succesfully! cd into .zsh/.."
    echo ". "
    cd $zshDirectory
fi

#####################################################
######                 .xcode                  ######
#####################################################

sleep 2
echo "Installing xcode CLI..."
# install xcode CLI
xcode-select --install
sleep 1

#####################################################
######                 .xcode                  ######
#####################################################

echo "Checking if Homebrew is installed..."
sleep 1
# Check if Homebrew is installed
if [ "$(which brew)" == "brew not found" ]; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Homebrew is already installed."
fi

##########################################
## Editors                               |
##########################################

echo ""
echo "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "What would you like it to be?"
  read COMPUTER_NAME
  sudo scutil --set ComputerName $COMPUTER_NAME
  sudo scutil --set HostName $COMPUTER_NAME
  sudo scutil --set LocalHostName $COMPUTER_NAME
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
fi

### TO BE CONTINIUED