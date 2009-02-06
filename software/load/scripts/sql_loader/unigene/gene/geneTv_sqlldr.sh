#!/bin/sh
echo Loading Gene_TV data  
$SQLPLUS $1 @GeneTv_preprocess.sql
$SQLLDR $1 readsize=1000000 direct=true silent=HEADER  control=gene_tv.ctl log=gene_tv.log bad=gene_tv.bad errors=5000
$SQLPLUS $1 @GeneTv_postprocess.sql 
echo Finished loading Gene_TV data 
