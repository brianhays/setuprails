#!/bin/sh

# This is the SetupRails script!
# 
# author: Brian Hays
# website: http://setuprails.com
#
# If you're viewing this in your web browser, and want to install Ruby on Rails...
# Open up your terminal and type:
#
#    sh <(curl -s https://raw.githubusercontent.com/brianhays/setuprails/master/setup_rails.sh)
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

RUBY_VERSION=2.2.0
GEMS_VERSION=2.4.6

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
##  3.) rbenv (to install and manage Ruby versions)
##  4.) Node (rails requires a javascript runtime)
##  5.) Rails (the latest & greatest stable version)
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
  echo "Installing Homebrew (note: you'll be prompted for your password during install)..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  read -p "Press any key to run 'brew doctor' and continue with the SetupRails script..."
  brew doctor
else
  echo "updating Homebrew..."
  brew update
fi

### Installing rbenv and ruby-build (to install and manage Ruby versions)
echo "Installing rbenv and ruby-build (to install and manage Ruby versions)..."
if type "rvm" &> /dev/null; then
  cat <<EOF
  Yikes! It appears you already have the Ruby manager 'RVM' installed on your system.
  rbenv is incompatible with RVM. If you want to proceed with installing rbenv,
  please make sure to FULLY uninstall RVM then re-run the SetupRails installer.
EOF
  exit 1
elif ! type "rbenv" &> /dev/null; then
  brew install rbenv ruby-build
  echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
  source ~/.bash_profile
fi

### Installing Ruby and setting default version
LOCAL_RUBY=$(ruby -v | awk '{print $2}')
if [[ "$LOCAL_RUBY" < "$RUBY_VERSION" ]] || ! type ruby &> /dev/null; then
  echo "Installing Ruby version $RUBY_VERSION ..."
  rbenv install $RUBY_VERSION
  rbenv rehash
  rbenv global $RUBY_VERSION
  source ~/.bash_profile
fi

### Updating RubyGems to latest version
LOCAL_RUBYGEMS=$(gem -v)
if [[ "$LOCAL_RUBYGEMS" < "$GEMS_VERSION" ]]; then
  echo "Updating the rubygems gem manager to latest version..."
  gem update --system
fi

### Installing node.js unless already installed
if ! type "node" &> /dev/null; then
  echo "Installing node.js (Rails requires a javascript runtime)"
  brew install node
fi

### Installing Rails!!! 
echo "Installing Rails!..."
gem install rails --no-ri --no-rdoc
rbenv rehash
RAILS_INSTALLED=$(rails -v)

### Installation complete
echo "#########################"
echo "Installation Complete!"
echo "#########################"
echo "Rails version $RAILS_INSTALLED has been successfully installed on your machine."

trap - EXIT
}

setup_rails