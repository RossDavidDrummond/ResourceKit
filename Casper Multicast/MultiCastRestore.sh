#!/bin/sh
####################################################################################################
#
# Copyright (c) 2010, JAMF Software, LLC
# All rights reserved.
#
#	Redistribution and use in source and binary forms, with or without
# 	modification, are permitted provided that the following conditions are met:
#		* Redistributions of source code must retain the above copyright
#		  notice, this list of conditions and the following disclaimer.
#		* Redistributions in binary form must reproduce the above copyright
#		  notice, this list of conditions and the following disclaimer in the
#		  documentation and/or other materials provided with the distribution.
#		* Neither the name of the JAMF Software, LLC nor the
#		  names of its contributors may be used to endorse or promote products
#		  derived from this software without specific prior written permission.
#
# 	THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
# 	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# 	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# 	DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
# 	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# 	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# 	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# 	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# 	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# 	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
#
# SUPPORT FOR THIS PROGRAM
#
# 	This program is distributed "as is" by JAMF Software, LLC's Resource Kit team. For more 
#	information or support for the Resource Kit, please utilize the following resources:
#
#		http://list.jamfsoftware.com/mailman/listinfo/resourcekit
#
#		http://www.jamfsoftware.com/support/resource-kit
#
#	Please reference our SLA for information regarding support of this application:
#
#		http://www.jamfsoftware.com/support/resource-kit-sla
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	MultiCastRestore.sh -- Restore an Image from a server over MultiCast ASR.
#
# SYNOPSIS
#	sudo MultiCastRestore.sh
#	sudo MultiCastRestore.sh <target> <computerName> <currentUsername> <server>
#
# 	If the $target parameter is passed from The Casper Suite, this is the volume to which the image
#	will be restored.  If the $server parameter is passed from the Casper Suite, this is the server
#	that will be referenced when looking for the image to restore.
#
#	If the target or server parameters are hardcoded in this script, they will override any
#	parameter that has been passed from The Casper Suite.
#
# DESCRIPTION
#	This script restores an image from a server running the Casper MultiCast Server tool.  The image
#	will be restored over a multicast session and should be run as a script with a priority of
#	"before" so that it restores the OS image before installing any other packages.  The script also
#	expects that the "Casper MultiCast Server" application is launched and and is actively serving
#	an image.  For more information on performing a multicast image restore, please see the
#	documentation for Casper MultiCast that is included in the JAMF Software Resource Kit.
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.2
#
#	- Created by Zach Halmstad on October 28th, 2007
#	- Modified by Nick Amundsen on August 11th, 2008
#	- Modified by Nick Amundsen on March 5th, 2009
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE
target=""
server=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 1 AND, IF SO, ASSIGN TO "target"
if [ "$1" != "" ] && [ "$target" == "" ];then
	target=$1
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "server"
if [ "$4" != "" ] && [ "$server" == "" ]; then
	server=$4
fi

####################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

if [ "$target" == "" ]; then
	echo "Error:  There is no value defined for the target parameter."
	exit 1
fi

if [ "$server" == "" ]; then
	echo "Error:  There is no value defined for the server parameter."
	exit 1
fi

devEntry=$(/usr/sbin/diskutil info "$target" | /usr/bin/grep "Device Node" | /usr/bin/awk '{print $3}')
echo "The dev entry for the disk to be restored: $devEntry"

originalName=$(/usr/sbin/diskutil info "$target" | /usr/bin/grep "Volume Name" | /usr/bin/grep -o '[^:]*$'  | /usr/bin/tr -s " " | /usr/bin/sed 's/^[ ]//g')
echo "The disk name: $originalName will be retained upon restoring."

echo "Initiating restore process and waiting for connection..."
/usr/sbin/diskutil unmount $devEntry
/usr/sbin/asr restore -source asr://$server -target "$devEntry" -erase -noprompt -timeout 0 -puppetstrings -noverify --verbose
/usr/sbin/diskutil mount $devEntry
/usr/sbin/diskutil rename $devEntry "$originalName"

exit 0;