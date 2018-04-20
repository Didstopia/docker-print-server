FROM didstopia/base:ubuntu-16.04

MAINTAINER Didstopia <support@didstopia.com>

# Fix apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    brother-lpr-drivers-extra brother-cups-wrapper-extra \
    cups cups-pdf \
    dbus \
    avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan \
    inotify-tools \
    python-cups && \
    rm -rf /var/lib/apt/lists/*

# Modify the CUPS configuration (based on https://github.com/schredder/cups-airprint/blob/master/Dockerfile)
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

# Set up volumes
VOLUME ["/config", "/services", "/etc/avahi/services"]

# Copy the scripts
ADD start.sh /start.sh
ADD printer-update.sh /printer-update.sh
ADD airprint-generate.py /airprint-generate.py

# Copy extra files
COPY README.md LICENSE.md /

# Set the current working directory
WORKDIR /

# Expose necessary ports
EXPOSE 631

# Expose environment variables
ENV CUPSADMIN "admin"
ENV CUPSPASSWORD "admin"

# Set the startup script
ENTRYPOINT ["./start.sh"]
