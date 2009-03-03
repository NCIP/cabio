LOAD DATA 
 
--INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/alignments_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/alignments_out_2.txt'
 
APPEND
 
INTO TABLE ar_alignments_tmp
 
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
