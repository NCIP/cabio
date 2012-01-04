#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=image_clone.ctl log=image_clone.log bad=image_clone.bad direct=true errors=50000
