#!/bin/sh
echo "Loading UniSTS Marker Data"
$SQLPLUS $1 @markerData_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=marker.ctl log=marker.log bad=marker.bad direct=true errors=5000 skip=1 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=markerAlias.ctl log=markerAlias.log bad=markerAlias.bad direct=true errors=5000 skip=1 &
wait
$SQLPLUS $1 @markerData_postprocess.sql
