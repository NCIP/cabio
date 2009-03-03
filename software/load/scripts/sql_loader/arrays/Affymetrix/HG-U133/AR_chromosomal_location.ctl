LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/chromosomal_location_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/chromosomal_location_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/chromosomal_location_out_3.txt'
 
APPEND
 
INTO TABLE ar_chromosomal_location_tmp

when GENECHIP_ARRAY <> 'GeneChip Array'

FIELDS TERMINATED BY ","
 
TRAILING NULLCOLS
(Probe_Set_ID,
buffer_field filler,
chromosomal_location,
cyto_start ,
cyto_stop ,
chromosome_number,
trim_chr,
assembly,
genechip_array,
chromosome_id)
