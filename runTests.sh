#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH
cabal build

cd $SCRIPTPATH/sandbox
../dist/build/tests/tests Configuration.yaml

