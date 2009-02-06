#!/bin/sh

# Commented out call to TSC SNP Data Load as data is no longer updated
$SQLPLUS $1 @provenance_preprocess.sql
$SQLLDR $1 readsize=1000000 control=snpProvenance.ctl log=snpProvenance.log bad=snpProvenance.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLLDR $1 readsize=1000000 direct=true silent=HEADER skip_index_maintenance=true control=geneProvenance.ctl log=geneProvenance.log bad=geneProvenance.bad errors=5000
$SQLLDR $1 readsize=1000000 direct=true silent=HEADER skip_index_maintenance=true control=nasProvenance.ctl log=nasProvenance.log bad=nasProvenance.bad errors=5000
$SQLLDR $1 readsize=1000000 control=proteinProvenance.ctl log=proteinProvenance.log bad=proteinProvenance.bad direct=true silent=(HEADER) skip_index_maintenance=true errors=50000
$SQLPLUS $1 @provenance_postprocess.sql &
