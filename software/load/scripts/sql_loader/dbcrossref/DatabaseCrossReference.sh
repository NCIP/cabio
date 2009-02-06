#!/bin/sh

# Commented out call to TSC SNP Data Load as data is no longer updated
$SQLPLUS $1 @dbCrossRef_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true control=DB_Crossreference.ctl log=DBCrossref.log bad=DBCrossref.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true 
$SQLPLUS $1 @DatabaseCrossReference.sql
$SQLPLUS $1 @dbCrossRef_postprocess.sql 
