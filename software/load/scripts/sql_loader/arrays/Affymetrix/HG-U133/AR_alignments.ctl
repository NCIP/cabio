LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/alignments_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/alignments_out_2.txt'
 
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
