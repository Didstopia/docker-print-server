#!/bin/bash

# Based on https://github.com/schredder/cups-airprint/blob/master/root/root/printer-update.sh

# Set up error handling
set -e
set -o pipefail

## Enable debugging
set -x

inotifywait -m -e close_write,moved_to,create /etc/cups | 
while read -r directory events filename; do
	if [ "$filename" = "printers.conf" ]; then
		echo "File /etc/cups/printers.conf changed.."
		#rm -rf /services/AirPrint-*.service
		#/airprint-generate.py -d /services
		rm -rf /etc/avahi/services/AirPrint-*.service
		/airprint-generate.py -d /etc/avahi/services
		cp /etc/cups/printers.conf /config/printers.conf
	fi
done
