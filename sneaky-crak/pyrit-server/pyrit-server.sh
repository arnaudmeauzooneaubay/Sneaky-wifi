#!/bin/bash

## Written by Arnaud Meauzoone april 2017

cmd="-h"

if [ -z "$1" ]
  then
    cmd="-h"
  else
    cmd=$1
fi

ipAdrr=$(cat server.conf)

wget -q -O - http://$ipAdrr/command --post-data $cmd
