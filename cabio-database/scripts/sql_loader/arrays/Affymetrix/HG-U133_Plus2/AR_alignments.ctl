LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133_Plus2/alignments_out.txt'
 
APPEND
 
INTO TABLE AR_alignments
 
REENABLE DISABLED_constraints 
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
chromosome_id
)
