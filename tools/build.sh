#!/bin/bash
# Set the tools dir as the base.
BASEPATH=`dirname $0`
CURDIR=`pwd`

cd $BASEPATH
./prebuild.sh
cd ../src

if [ "$1" = "neko" ]
then
  echo Building haXigniter for neko...
  haxe haxigniter_neko.hxml
else
  echo Building haXigniter for php...
  haxe haxigniter_php.hxml
fi

cd $CURDIR
