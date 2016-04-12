#!/bin/bash

#$1 the folder to map to rock

#$2 -h <name> setting a name of the machine 

#mit x geraffel
docker run -ti -P --user exoter -w /home/exoter --name exoter_container  -e DSUPPORT=1 $2 exoter:14.04
#ports: -p 10245:10245 -p 8765:8765/udp
 
#--expose=10245 --expose=8765 --expose=8766 -p 8765:8765/udp #ggf wieder anhängen

#ohne x geraffel:
#sudo docker run -ti --expose=10245 -P --dns 10.250.0.1 --name enternC -v $1:/home/entern/rock -v ~/.ssh:/home/entern/.ssh localhost:5000/entern
