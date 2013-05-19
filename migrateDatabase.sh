#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH

$SCRIPTPATH/dist/build/migrateDatabase/migrateDatabase --configFile=sandbox/Configuration.yaml "$@"

