# Name of this build's configuration file without the extension (the yaml
# file that is used by autoproj to store the build configuration). If you
# do not have anything more in your autoproj configuration than what is
# needed by the rock build configuration, use default-FLAVOR (where FLAVOR
# is the main Rock flavor
#
# If your project does require specific (autoproj) configuration variables,
# contact robot-toolchain@dfki.de to get someone to put the configuration
# file in the relevant repository
# CONFIG_NAME=default-next
# The URL to the git repository that holds the configuration
BUILDCONF_REPOSITORY=https://github.com/exoter-rover/buildconf.git
#the branch of the buildconf repository to use (default:master)
BUILDCONF_BRANCH=master

# Fill in the environment variables above and delete the following lines
# (until and including the "exit 1" line)
#exit 1

#use an local cahc eof repositories
#be careful about enabling this, you need to update the cache before
#new commits can be used, the cache contains all opensource packages
#but it speeds up the update phase of jenkins builds
#export AUTOPROJ_CACHE_DIR=/data/jenkins/autoproj_cache

#select the number of lines displayed on errors ('number' or 'ALL')
export DISPLAYED_ERROR_LINE_COUNT=\'ALL\'

#setup ccache (must be AFTER icecc)
#ccache works per OS node, so cached versions may come from other
#projects when compiling your project
export PATH=/usr/lib/ccache:$PATH #use the ccache compilers
export CCACHE_PREFIX=icecc
export CCACHE_DIR=/data/jenkins/ccache
#do not write the ccache, only read
#export CCACHE_READONLY=true

#"normal" setup
export LANG=en_US.UTF-8
#export RUBY=/usr/bin/ruby1.9.1
#export GEM=/usr/bin/gem1.9.1

#Special hadling ubuntu 14.04 has only ruby2.0 availible :-/
if [ "$NODE_NAME" = "Ubuntu_14.04" ]; then
    export RUBY=/usr/bin/ruby2.0
    export GEM=/usr/bin/gem2.0
    echo "Override ruby version for ubuntu 14.04 see job config"
fi

export CONFIG_NAME
export CONFIG_DIR
export BUILDCONF_BRANCH
#export KEEP_GOING=true #execute the build with -k option
wget https://github.com/rock-core/base-build_server_scripts/raw/master/rock_build
mkdir dev
wget --output-document=./dev/default-stable.yml https://github.com/rock-core/base-build_server_scripts/raw/master/default-stable.yml
sh rock_build git $BUILDCONF_REPOSITORY branch=$BUILDCONF_BRANCH
