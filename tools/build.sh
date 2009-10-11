#!/bin/bash
# Set the tools dir as the base.
BASEPATH=`dirname $0`
SRCPATH=$BASEPATH/../src

if [ "$1" == "-help" ] || [ "$1" == "--help" ]
then
	echo "haXigniter build script"
	echo " Usage: `basename $0` [outputdir] [-neko]"
	echo " src/haxigniter.hxml can be used for custom arguments and libraries."
	exit
fi

# If no path is specified, use default.
if [ -z "$1" ] || [ "$1" == "-neko" ]
then
	OUTPUT=$BASEPATH/../bin/www
else
	OUTPUT=$1
fi

# Strip end slash if it exists
if [ "${OUTPUT:(-1)}" == "/" ]
then
	OUTPUT=${OUTPUT:0:${#OUTPUT}-1}
fi

# Test if hxml file exists, then include it.
if [ -e "$BASEPATH/haxiginiter.hxml" ]
then
	BUILDFILE="$BASEPATH/haxiginiter.hxml"
else
	BUILDFILE=
fi

$BASEPATH/prebuild.sh "$OUTPUT"

if [ "$1" = "-neko" ] || [ "$2" = "-neko" ]
then
  echo Building haXigniter for Neko...
  haxe -cp "$SRCPATH" -neko "$OUTPUT/index.n" -main haxigniter.Application $BUILDFILE
else
  echo Building haXigniter for PHP...
  haxe -cp "$SRCPATH" -php "$OUTPUT" -main haxigniter.Application $BUILDFILE
fi
