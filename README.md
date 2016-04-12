## ExoTeR Rock Dockerfile

![alt tag](https://github.com/exoter-rover/docker-taste/raw/master/exoter_docker_logo.jpg)

This repository contains **Dockerfile** of [rock](http://rock-robotics.org) for
[Docker](https://www.docker.com/)'s [automated
build](https://registry.hub.docker.com/u/exoter/rock/) published to the
public [Docker Hub Registry](https://registry.hub.docker.com/).


### Base Docker Image

* [ubuntu:14.04](https://hub.docker.com/r/i386/ubuntu/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/exoter/rock/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull exoter/rock

   (alternatively, you can build an image from Dockerfile: `docker build -t exoter/rock:14.04 github.com/exoter-rover/docker-rock )

### Usage

    docker run -it --rm exoter/rock:14.04

    You can also use the script file docker-run-exoter.sh as following:
    sh docker-run-exoter.sh . "-h docker"


