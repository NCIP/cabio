#sed -e 's/   */|/g' -e 's/pid_geneentity/pid_geneentity|/g' -e 's/pid_complex_participant_ptm /pid_complex_participant_ptm|/g' -e 's/pid_complex_participant_location /pid_complex_participant_location|/g'  -e 's/pid_family_participant_ptm /pid_family_participant_ptm|/g' -e 's/\t/|/g' /cabio/cabiodb/cabio_data/pid/dump/combinedDump.120208 > /cabio/cabiodb/cabio_data/pid/dump/combined_dump.120208.dat  
$SQLPLUS $1 @preprocess.sql  
$SQLLDR $1 readsize=1000000 parallel=true control=caBIGDataDump.ctl log=caBIGDataDump.log bad=caBIGDataDump.bad errors=50000 direct=true silent=(HEADER) 
$SQLPLUS $1 @load_tmp_tables.sql 
$SQLPLUS $1 @postprocess.sql 
exit;
$SQLPLUS $1 @update_pathways.sql 
 
