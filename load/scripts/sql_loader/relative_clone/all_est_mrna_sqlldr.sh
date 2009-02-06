#!/bin/sh

echo "Loading EST and MRNA Annotations for Human and Mouse from UCSC"
$SQLPLUS $1 @estmrnaData_preprocess.sql 
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_human_est.ctl log=zstg_human_est.log bad=zstg_human_est.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_mouse_est.ctl log=zstg_mouse_est.log bad=zstg_mouse_est.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_human_mrna.ctl log=zstg_human_mrna.log bad=zstg_human_mrna.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_mouse_mrna.ctl log=zstg_mouse_mrna.log bad=zstg_mouse_mrna.bad direct=true silent=HEADER skip_index_maintenance=true errors=5000 &
wait
$SQLPLUS $1 @estmrnaData_postprocess.sql 
exit;
