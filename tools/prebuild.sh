#!/bin/bash
# Set the tools dir as the base.
BASEPATH=`dirname $0`

# Set paths
OUTPUT=$BASEPATH/../bin/www/lib/haxigniter/application
APP=$BASEPATH/../src/haxigniter/application

mkdir -p $OUTPUT

# ----- .htaccess --------------------------------------------------

# Copy .htaccess to lib folder
rsync -a $BASEPATH/../src/.htaccess $BASEPATH/../bin/www/lib/

# ----- Runtime ----------------------------------------------------

# Copy runtime folders to application
rsync -a --exclude=.gitignore $APP/runtime $OUTPUT

# ----- Synchronize views ------------------------------------------

rsync -a --delete --exclude=.gitignore $APP/views $OUTPUT

# ----- Synchronize external libraries -----------------------------

rsync -a --delete --exclude=.gitignore --exclude=*.hx $APP/external $OUTPUT
