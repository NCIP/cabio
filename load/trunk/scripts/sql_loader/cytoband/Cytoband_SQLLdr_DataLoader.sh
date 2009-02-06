#!/bin/sh

echo "Loading Human and Mouse Cytoband Data using SQL Loader"
$SQLPLUS $1 @cytobandData_preprocess.sql
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_mouse_cytoband_sqlldr.ctl log=zstg_mouse_cytoband_sqlldr.log bad=zstg_mouse_cytoband_sqlldr.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_human_cytoband_sqlldr.ctl log=zstg_human_cytoband_sqlldr.log bad=zstg_human_cytoband_sqlldr.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000
$SQLPLUS $1 @cytobandData_postprocess.sql
echo "Finished loading Human and Mouse Cytoband Data"
