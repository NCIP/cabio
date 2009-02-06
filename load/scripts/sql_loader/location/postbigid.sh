#!/usr/bin/sh

sqlplus $1 @addCytogenicLocations.sql
sh exontranscriptLocationLoad.sh $1
exit
