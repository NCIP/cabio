LOAD DATA 
 
INFILE "$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/alignments_out.txt"
INFILE "$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/alignments_out_2.txt"
INFILE "$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/alignments_out_3.txt"
 
APPEND
 
INTO TABLE ar_alignments_tmp

when GENECHIP_ARRAY <> 'GeneChip Array'


FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
chromosome,
start_position,
end_position,
direction,
trim_chr,
assembly,
genechip_array,
chromosome_id)
