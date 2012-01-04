LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/marker/human/seq_sts.md'
INFILE '$CABIO_DATA_DIR/marker/mouse/seq_sts.md'

APPEND
 
INTO TABLE zstg_seqsts 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
(tax_id "DECODE(:tax_id,9606,5,6)",
chromosome,
chr_start,
chr_stop,
chr_orient,
contig,
ctg_start,
ctg_stop,
ctg_orient,
feature_name,
feature_id,
feature_type,
group_label,
weight)
