#!/bin/bash
# Image to test
: ${TAG:=latest}

# Hostname to test connections
CONTAINER_HOST=localhost
if boot2docker 2> /dev/null && [ $( boot2docker status ) = "running" ]; then
  CONTAINER_HOST=$( boot2docker ip )
fi

remove_container_by_name() {
    NAME=$1
    C_ID=$( docker ps -a --no-trunc --filter name=^/${NAME}$|grep -v "CONTAINER" |tail -1|awk '{print $1;}' )
    if [ ! -z "$C_ID" ]; then
        docker container stop $C_ID
	docker container rm $C_ID
    fi;
}