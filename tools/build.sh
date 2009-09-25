#!/bin/bash
# Set the tools dir as the base.
BASEPATH=`dirname $0`
CURDIR=`pwd`

cd $BASEPATH
./prebuild.sh
cd ../src
haxe haxigniter.hxml
cd $CURDIR
