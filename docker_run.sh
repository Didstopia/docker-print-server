#!/bin/bash

./docker_build.sh

#docker run -p 0.0.0.0:631:631 -v $(pwd)/data/config:/config -v $(pwd)/data/services:/services --name docker-print-server -it --rm didstopia/docker-print-server:latest
docker run -p 0.0.0.0:631:631 -v $(pwd)/data/config:/config -v $(pwd)/data/services:/etc/avahi/services --name docker-print-server -it --rm didstopia/docker-print-server:latest
