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

### NOTE sh NOT bash. This script should be POSIX sh

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

### echo for TESTING ONLY ###
echo "$UNAME"
echo "$OSX_VERSION"
#############################

trap - EXIT
}

setup_rails