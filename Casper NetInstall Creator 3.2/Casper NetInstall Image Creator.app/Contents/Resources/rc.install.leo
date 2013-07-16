#!/bin/sh
# $Id: rc.install,v 1.13 2007/09/06 18:54:38 pmb Exp $
# Copyright 2000-2007, Apple Inc.
# pmb

#
# Disable prebinding-on-the-fly while we're CD booted
#
export DYLD_NO_FIX_PREBINDING=1

#
# Source the preheat script if it exists; a poor-man's alternative to a valid boot cache
#
if [ -x /System/Installation/CDIS/preheat.sh ]; then
	/System/Installation/CDIS/preheat.sh
fi

#
# Check for GUI Crash Catcher
#
LOGVIEWER="/System/Installation/CDIS/Installation Log.app/Contents/MacOS/Installation Log"
if [ -x "${LOGVIEWER}" ]; then
  CatchExit=GUI
else
  CatchExit=CLI
fi

#
# start the external log buffer
#
#/System/Installation/CDIS/instlogd &

#
# Set default power management policy for the Install CD
#
(sleep 30; /usr/bin/pmset force -a sleep 0 displaysleep 0 powerbutton 0 disksleep 0 ) &

#
# Source a local configuration script if present
#
if [ -x /etc/rc.cdrom.local ]; then
	/etc/rc.cdrom.local
fi

#
# Source a pre-WindowServer script if present
# (This is inaccurate, the WindowServer is now started on demand.)
#
if [ -x /etc/rc.cdrom.preWS ]; then
	/etc/rc.cdrom.preWS
fi

#
# Source a post-WindowServer script if present
# (This is inaccurate, the WindowServer is now started on demand.)
#
if [ -x /etc/rc.cdrom.postWS ]; then
	/etc/rc.cdrom.postWS
fi

#
# log our boot time for performance stats
#
sysctl kern.boottime | head -1 | /usr/bin/logger -t "" -p install.debug

#
# The Launcher is responsible for the progress bar while the Installer loads
#
LAUNCH=/System/Installation/CDIS/LCA.app/Contents/MacOS/LCA

if [ ! -x ${LAUNCH} ]; then
  LAUNCH=/System/Installation/CDIS/splash
fi

#
# The Installer installs
#
OSINSTALLER="/System/Installation/CDIS/Mac OS X Installer.app/Contents/MacOS/Mac OS X Installer"
INSTALLER=/System/Library/CoreServices/Installer.app/Contents/MacOS/Installer

# Customized NetInstall systems may not contain Mac OS X Installer
#
if [ ! -x "${OSINSTALLER}" ]; then
        OSINSTALLER="${INSTALLER}"
fi

#
# Common & extra installer command line arguments
#
STDARGS="-ExternalLog YES -NSDisabledCharacterPaletteMenuItem YES"
EXTRAARGS=`cat /System/Installation/CDIS/AdditionalInstallerArgs 2>/dev/null`
MINSTALL_CONF=/etc/minstallconfig.xml 

INSTALL_PKG=/System/Installation/Packages/OSInstall.mpkg
if [ -f /System/Installation/Packages/OSInstall.collection ]; then
        INSTALL_PKG=/System/Installation/Packages/OSInstall.collection
fi

#
# Start the installer, optionally with a custom package
#
while [ ! -f /var/run/installer ]; do

  touch /var/run/installer
  # if it's still there when LCA exits, we assume something crashed
  # if the installer unlinks it before exiting, we re-launch LCA
  # if LCA exit()s after launching the installer, we won't see the exit(76) from the installer, and neither will rc.cdrom
  # if LCA hangs around while Installer runs, it'll catch the exit(76) and we won't come back to rc.cdrom
  # (LCA exit()s after launching the installer when memory is tight)

  if [ -e ${MINSTALL_CONF} ]; then
    # no splash or lang chooser for autoinstalls
    CatchExit=Minstaller
    MINSTALL_LANG=`perl -e '$d .= $_ while(<>); $d =~ m|<key>[Ll]anguage</key>\W+<string>(\w+)</string>|m; print $1;' < ${MINSTALL_CONF}`
    MINSTALL_LANG=${MINSTALL_LANG:-English}
    /usr/bin/logger -t "" -p install.info "Launching the Installer using ${MINSTALL_CONF} file with language ${MINSTALL_LANG}."
    "${OSINSTALLER}"                                \
            -f ${MINSTALL_CONF}                     \
            -AppleLanguages "(${MINSTALL_LANG})"    \
            ${STDARGS}                              \
            ${EXTRAARGS}                            \
            2>&1 | /usr/bin/logger -t "" -p install.warn

  elif [ -f /etc/rc.cdrom.packagePath ]; then
    /usr/bin/logger -t "" -p install.info "Launching the Language Chooser for a custom package"
    ${LAUNCH} "${INSTALLER}"                        \
            ${STDARGS}                              \
            ${EXTRAARGS}                            \
            "`head -1 /etc/rc.cdrom.packagePath`"   \
            2>&1 | /usr/bin/logger -t "" -p install.warn

  else
    export OS_INSTALL=1
    /usr/bin/logger -t "" -p install.info "Launching the Language Chooser for an OS Install"
    ${LAUNCH} "${OSINSTALLER}"                           \
            -ReadVerifyMedia YES                         \
            ${STDARGS}                                   \
            ${EXTRAARGS}                                 \
            ${INSTALL_PKG}                               \
            2>&1 | /usr/bin/logger -t "" -p install.warn
  fi
done

reboottype=1

if [ "${CatchExit}_" = "GUI_" ]; then
  /usr/bin/logger -t "" -p install.alert "Launching the Installer Crash Log Viewer"
  "${LOGVIEWER}" -ExternalLog YES
  reboottype=$?
  kill `ps -axwww | awk '/Window[S]erver/ {print $1}'`
  echo
elif [ "${CatchExit}_" = "CLI_" ]; then
  kill `ps -axwww | awk '/Window[S]erver/ {print $1}'`
  echo
  echo "The Installer has quit due to an unexpected error."
  echo
  echo "Type 'exit' to reboot."
  sh
elif [ "${CatchExit}_" = "Minstaller_" ]; then
  /sbin/reboot
else  
  kill `ps -axwww | awk '/Window[S]erver/ {print $1}'`
  echo
  echo
  echo "The Installer has quit due to an unexpected error."
  echo
  echo
  echo "Please restart your computer."
  echo
  echo
  read
fi

if [ "${reboottype}_" = "1_" ]; then
  /sbin/reboot
else
  /sbin/halt
fi

