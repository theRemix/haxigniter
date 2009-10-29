#!/bin/bash
# Unit test runner

OLDDIR=`pwd`
cd `dirname $0`/unittest

haxe -cp ../../src -main UnitTest -neko unittest.n
neko unittest.n $1
rm -f unittest.n

cd $OLDDIR
