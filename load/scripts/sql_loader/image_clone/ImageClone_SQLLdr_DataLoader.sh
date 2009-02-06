#!/bin/sh
echo "Loading IMAGE Clone data using SQL Loader"
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_image_clone_sqlldr.ctl log=zstg_image_clone.log bad=zstg_image_clone.bad direct=true errors=50000
echo "Finished loading IMAGE Clone data"
