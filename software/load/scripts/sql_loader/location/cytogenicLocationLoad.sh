#!/bin/sh

# Commented out call to TSC SNP Data Load as data is no longer updated
$SQLPLUS $1 @cytogenicLocation_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true control=cytoCytoloc.ctl log=cytoCytoloc.log bad=cytoCytoloc.bad errors=50000 silent=(HEADER)
$SQLLDR $1 readsize=1000000 parallel=true control=snpCytoloc.ctl log=snpCytoloc.log bad=snpCytoloc.bad errors=50000 silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 parallel=true control=geneCytoloc.ctl log=geneCytoloc.log bad=geneCytoloc.bad errors=50000 silent=(HEADER) skip_index_maintenance=true 
$SQLPLUS $1 @cytogenicLocation_postprocess.sql
exit
