sed -e 's/   */|/g' -e 's/pid_geneentity/pid_geneentity|/g' -e 's/pid_complex_participant_ptm /pid_complex_participant_ptm|/g' -e 's/pid_complex_participant_location /pid_complex_participant_location|/g'  -e 's/pid_family_participant_ptm /pid_family_participant_ptm|/g' -e 's/\t/|/g'  -e 's/| /|/g' -e 's/||/|/g' /cabio/cabiodb/cabio_data/pid/dump/current.cabig > /cabio/cabiodb/cabio_data/pid/dump/current.cabig.dat
rm pid_data.dat  
ln -sf /cabio/cabiodb/cabio_data/pid/dump/current.cabig.dat /cabio/cabiodb/cabio_data/pid/dump/pid_data.dat

awk -F'\t' '{print $1"|"$3"|"$2}' /cabio/cabiodb/cabio_data/pid/dump/uniprot.tab > /cabio/cabiodb/cabio_data/pid/dump/uniprot_pathway.dat

$SQLPLUS $1 @preprocess.sql  
$SQLLDR $1 readsize=1000000 parallel=true control=caBIGDataDump.ctl log=caBIGDataDump.log bad=caBIGDataDump.bad errors=50000 direct=true silent=(HEADER) 
$SQLPLUS $1 @load_tmp_tables.sql 
$SQLPLUS $1 @postprocess.sql 
$SQLPLUS $1 @update_pathways.sql 
$SQLLDR $1 readsize=1000000 parallel=true control=pathway_gene_object.ctl log=pathway_gene_object.log bad=pathway_gene_object.bad errors=50000 direct=true silent=(HEADER) 
exit; 
