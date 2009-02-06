#!/bin/sh

# Commented out call to TSC SNP Data Load as data is no longer updated
$SQLPLUS $1 @snpData_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true control=SNP_Data_Loader.ctl log=SNP_Data_Loader.log bad=SNP_Data_Loader.bad errors=50000 direct=true silent=(HEADER)  
wait

$SQLPLUS $1 @snpData_postprocess.sql 
$SQLPLUS $1 @updateWithArrayData.sql &
