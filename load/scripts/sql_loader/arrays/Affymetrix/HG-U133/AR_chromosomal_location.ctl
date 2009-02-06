LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/chromosomal_location_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/chromosomal_location_out_2.txt'
 
APPEND
 
INTO TABLE ar_chromosomal_location_tmp
 
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
