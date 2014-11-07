#!/bin/sh

# This is the SetupRails script!
# 
# author: Brian Hays
# website: (coming soon)
#
# If you're viewing this in your web browser, and want to install Ruby on Rails...
# Open up your terminal and type:
#
#    curl (installer site coming soon)
#
# SetupRails currently supports:
#   - Mac: OS X 10.9 and above
# 
# (coming soon = Linux: x86 and x86_64 systems)

# This script is wrapped in a function, so that it won't execute until
# the whole script is downloaded.
# This prevents our output overlapping with curl's. That's great news 
# because it also means we can't run a partially downloaded script.

setup_rails () {


### Now, on to the actual installer...

set -e
set -u

# We're displaying everything on stderr.
exec 1>&2


UNAME=$(uname)
if [ "$UNAME" != "Darwin" ] ; then
    echo "Sorry, this installer only support Mac OSX at this time."
    exit 1
fi


if [ "$UNAME" = "Darwin" ] ; then
  ### OSX ###
  OSX_VERSION=$(sw_vers -productVersion | awk 'BEGIN{FS=".";} {print $2}' )
  if [ "$OSX_VERSION" != "10" -a "$OSX_VERSION" != "9" ] ; then
    echo "Only OSX Yosemite and Mavericks are supported at this time."
    exit 1
  fi
fi

clear
cat <<EOF
##########################
##########################
##  Welcome to SetupRails!
##
##  This installer was designed to ease the installation process
##  for a typical Ruby on Rails development machine.
##
##  You may be prompted several times for your password as packages
##  are installed on your system. If you're new to the Terminal command line
##  you may notice that no visual feedback is provided when typing your
##  password. This is normal :)
##
##  Before we get started, here is a quick rundown of the steps
##  and the packages that get installed:
##
##  1.) XCode command-line-tools (you will see a confirmation box - click Install)
##  2.) Homebrew (dubbed 'the missing package manager for OSX')
##  3.) Ruby (the latest stable version will be installed via rbenv)
##  4.) Bundler 
##  5.) SQLite3
##  6.) Node
##  7.) Rails (last but certainly not least!!)
##
##########################
EOF
read -p "Press any key to continue..."

### Installing command-line-tools unless already installed
if [ ! -d "/Library/Developer/CommandLineTools" ]; then
  echo "Installing command-line-tools. Click Install (NOT get XCode) when prompted"
  xcode-select --install
  read -p "Once the command-line-tools installer completes, Press any key to continue:"
fi

### Installing Homebrew or updating if already installed
if ! type "brew" &> /dev/null; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

### echo for TESTING ONLY ###
echo "$UNAME"
echo "$OSX_VERSION"
#############################

trap - EXIT
}

setup_rails