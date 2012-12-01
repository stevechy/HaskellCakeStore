#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH/sandbox
../dist/build/cakeStore/cakeStore Configuration.yaml

