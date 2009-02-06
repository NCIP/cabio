#!/bin/sh

# Commented out call to TSC SNP Data Load as data is no longer updated
perl generate_exon_transcript_phyloc.pl 1>>locationGeneration.log 2>&1
$SQLLDR $1 readsize=1000000 parallel=true control=exonPhyloc.ctl log=exonPhyloc.log bad=exonPhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 parallel=true control=transcriptPhyloc.ctl log=transcriptPhyloc.log bad=transcriptPhyloc.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
sqlplus $1 @location_postprocess.sql
exit
