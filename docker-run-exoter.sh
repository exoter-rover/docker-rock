#!/bin/bash

#$1 the folder to map to rock

#$2 -h <name> setting a name of the machine 

#mit x geraffel
#docker run -ti -P -v /dev/dri:/dev/dri:rw -u exoter -v /tmp/.X11-unix:/tmp/.X11-unix -v /usr/lib/nvidia-340-updates:/usr/lib/nvidia-340-updates --dns 10.250.0.1 --name exoter_container -v $1:/home/exoter/dev -v ~/.ssh:/home/exoter/.ssh -v /dev/video0:/dev/video0:rw -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro  -e DSUPPORT=1 $2 exoter:14.04
docker run -ti -P -v /dev/dri:/dev/dri:rw -u exoter --name exoter_container -e DSUPPORT=1 $2 exoter/rock:14.04
#ports: -p 10245:10245 -p 8765:8765/udp
 
#--expose=10245 --expose=8765 --expose=8766 -p 8765:8765/udp #ggf wieder anhängen

#ohne x geraffel:
#sudo docker run -ti --expose=10245 -P --dns 10.250.0.1 --name exoterC -v $1:/home/exoter/rock -v ~/.ssh:/home/exoter/.ssh localhost:5000/exoter
