#!/bin/sh
echo Loading clone_tv and clone_taxon tables
$SQLPLUS $1 @cloneTables_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true direct=true silent=HEADER  control=clone_tv.ctl log=clone_tv.log bad=clone_tv.bad errors=5000 &
$SQLLDR $1 readsize=1000000 control=zstg_clone.ctl parallel=true  log=zstg_clone.log bad=zstg_clone.bad direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 parallel=true direct=true silent=HEADER  control=clone_taxon.ctl log=clone_taxon.log bad=clone_taxon.bad errors=5000 &
$SQLLDR $1 readsize=1000000 parallel=true direct=true silent=HEADER  control=clone_relative_location.ctl log=clone_relative_location.log bad=clone_relative_location.bad errors=5000 &
wait
$SQLPLUS $1 @cloneTables_postprocess.sql &
echo Finished loading clone_tv and clone_taxon tables

