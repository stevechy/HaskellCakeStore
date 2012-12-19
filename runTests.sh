#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH
cabal build
 
rc=$?
if [[ $rc != 0 ]] 
 then
   exit 1
fi

cd $SCRIPTPATH/sandbox
../dist/build/tests/tests Configuration.yaml

