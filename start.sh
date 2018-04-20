#!/bin/bash

# Based on https://github.com/schredder/cups-airprint/blob/master/root/root/run_cups.sh

# Set up error handling
set -e
set -o pipefail

## Enable debugging
set -x

# Set up the CUPS user if necessary
if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
  echo "CUPS admin is missing, creating a new user.."
  useradd -r -G lpadmin -M $CUPSADMIN 
fi
echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

# Make sure the correct directores and files exist
mkdir -p /config/ppd
#mkdir -p /services
rm -rf /etc/cups/ppd
ln -s /config/ppd /etc/cups
if [ ! -f /config/printers.conf ]; then
  echo "File /config/printers.conf is missing, creating an empty file.."
  touch /config/printers.conf
fi
cp /config/printers.conf /etc/cups/printers.conf

# Start the services
service dbus start
service avahi-daemon start
/printer-update.sh &
exec /usr/sbin/cupsd -f
