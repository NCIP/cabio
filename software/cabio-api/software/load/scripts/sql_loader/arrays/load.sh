
sqlplus $1 @update_arrays.sql 
sqlplus $1 @zstg_popfreq_ld.sql 
perl generate_popfreq.pl

sqlplus $1 @popFreq_pre.sql 
$SQLLDR $1 readsize=1000000 parallel=true control=popFreq.ctl log=popFreq.log bad=popFreq.bad errors=50000 direct=true silent=(HEADER)
sqlplus $1 @popFreq_post.sql

wait
