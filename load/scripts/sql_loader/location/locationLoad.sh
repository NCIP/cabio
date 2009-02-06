#!/bin/sh

$SQLPLUS $1 @createCytoTables.sql
perl generate_nas_cyto_phyloc.pl 1>locationGeneration.log 2>&1
$SQLPLUS $1 @location_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true control=cytobandPhyloc.ctl log=cytobandPhyloc.log bad=cytobandPhyloc.bad errors=50000 direct=true silent=(HEADER)
$SQLLDR $1 readsize=1000000 parallel=true control=snpPhyloc.ctl log=snpPhyloc.log bad=snpPhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 parallel=true control=nasPhyloc.ctl log=nasPhyloc.log bad=nasPhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 parallel=true control=genePhyloc.ctl log=genePhyloc.log bad=genePhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 parallel=true control=markerPhyloc.ctl log=markerPhyloc.log bad=markerPhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
sh cytogenicLocationLoad.sh $1
exit
