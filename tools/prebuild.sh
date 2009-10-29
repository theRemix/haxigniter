#!/bin/bash
BASEPATH=`dirname $0`
SRCPATH=$BASEPATH/../src

# Set output path
if [ -z "$1" ]
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

# Set paths
OUTPUTAPP=$OUTPUT/lib/haxigniter/application
APPSRC=$SRCPATH/haxigniter/application

mkdir -p "$OUTPUTAPP"

# ----- Synchronize resources if folder exists ----------------------

if [ -e "$APPSRC/resources" ]
then
	rsync -a --delete --exclude=.gitignore --exclude=lib/ "$APPSRC/resources/" "$OUTPUT"
fi

# ----- .htaccess ---------------------------------------------------

# Copy .htaccess to lib folder
rsync -a "$SRCPATH/.htaccess" "$OUTPUT/lib/"

# ----- Runtime -----------------------------------------------------

# Copy runtime folders to application
rsync -a --exclude=.gitignore "$APPSRC/runtime" "$OUTPUTAPP"

# ----- Synchronize views -------------------------------------------

rsync -a --delete --exclude=.gitignore "$APPSRC/views" "$OUTPUTAPP"

# ----- Synchronize external libraries ------------------------------

rsync -a --delete --exclude=.gitignore --exclude=*.hx "$APPSRC/external" "$OUTPUTAPP"
