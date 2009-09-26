#!/bin/bash
# Set the tools dir as the base.
BASEPATH=`dirname $0`
SRCPATH=$BASEPATH/../src

if [ -z "$1" ] || [ "$1" == "-neko" ]
then
	OUTPUT=$BASEPATH/../bin/www
else
	OUTPUT=$1
fi

./prebuild.sh $OUTPUT

if [ "$1" = "-neko" ] || [ "$2" = "-neko" ]
then
  echo Building haXigniter for neko...
  haxe -cp $SRCPATH -neko $OUTPUT/index.n -main haxigniter.Application
else
  echo Building haXigniter for php...
  haxe -cp $SRCPATH -php $OUTPUT -main haxigniter.Application
fi
