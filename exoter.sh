#!/bin/bash
if [ "$1" == "start" ]; then
	docker start -ai exoter_container
fi

if [ "$1" == "enter" ]; then
	docker exec -ti exoter_container bash
fi
