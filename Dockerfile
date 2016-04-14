FROM ubuntu:14.04

MAINTAINER "Javier Hidalgo Carrio" <javier.hidalgo_carrio@dfki.de>

# Make the binfmt_misc pseudo-filesystem available at boot.
#RUN echo "binfmt_misc /proc/sys/binfmt_misc binfmt_misc none" >> $ROOTFS/etc/fstab
#RUN mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
#RUN echo ":CLR:M::MZ::/usr/bin/mono:" > $ROOTFS/proc/sys/fs/binfmt_misc/register

# Create Taste user
RUN sudo adduser  --disabled-password --gecos -m exoter && adduser exoter sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# For the init script
RUN echo 'exoter ALL = NOPASSWD: /usr/local/bin/start.sh' >> /etc/sudoers

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Upgrade the current system
RUN DEBIAN_FRONTEND=noninteractive && sudo apt-get upgrade -y -q

#  Installing required packages:
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive

RUN DEBIAN_FRONTEND=noninteractive &&\
            sudo apt-get update &&\
            sudo apt-get install -y -q --no-install-recommends build-essential\
            vim wget ruby-full git ruby-dev ruby2.0 ruby2.0-dev xterm rake\
            figlet libpam-systemd unzip subversion
# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``
#RUN apt-get clean

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Change to exoter user
ENV HOME /home/exoter
WORKDIR $HOME
USER exoter


# Get ROCK bootstrap file
ENV BOOTSTRAP_URL=http://rock-robotics.org/autoproj_bootstrap
ENV AUTOPROJ_OSDEPS_MODE=all
ENV RUBY=ruby2.0
ENV GEM=gem2.0
RUN wget ${BOOTSTRAP_URL}

# Create dev folder
RUN mkdir -p $HOME/dev
WORKDIR $HOME/dev
ENV AUTOPROJ_CURRENT_ROOT=$HOME/dev
ENV AUTOPROJ_BOOTSTRAP_IGNORE_NONEMPTY_DIR=1
ENV GEM_HOME=${AUTOPROJ_CURRENT_ROOT}/.gems

# Updtae gem
RUN $GEM update

# Run ROCK installation
RUN ${RUBY} ../autoproj_bootstrap --no-color --no-progress git https://github.com/exoter-rover/buildconf.git branch=master

# ENV variables
ENV GEM_PATH=${GEM_HOME}:$GEM_PATH
ENV PATH ${GEM_HOME}/bin:$PATH
ENV RUBYOPT=-rubygems
ENV PYTHONUSERBASE=${AUTOPROJ_CURRENT_ROOT}/.pip
ENV BUILDFLAGS=' -p15'
RUN echo $PATH

# Source env.sh
RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh
RUN source ./env.sh
RUN ls -la

# Copy defualt config file
WORKDIR $HOME/dev/autoproj
RUN rm -f config.yml
RUN wget https://github.com/exoter-rover/docker-rock/raw/master/config.yml
RUN ls -la

# Update rock
WORKDIR $HOME/dev
RUN git config --global user.email "exoter@exoter.com" && git config --global user.name "exoter"
RUN echo 'Autobuild.displayed_error_line_count = '\''ALL'\'''
RUN cat ./autoproj/config.yml
RUN $RUBY --version
RUN $GEM --version
RUN autoproj test --disable
RUN DEBIAN_FRONTEND=noninteractive && autoproj --no-color --no-progress update
RUN DEBIAN_FRONTEND=noninteractive && autoproj --no-color build -p4

##################### INSTALLATION END #####################
# Home directory
WORKDIR $HOME

# Set default container command entrypoint
ENTRYPOINT figlet exoter && /bin/bash

