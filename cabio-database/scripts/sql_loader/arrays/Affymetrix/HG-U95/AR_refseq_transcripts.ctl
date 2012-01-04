LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/refseq_transcript_id_out_3.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/refseq_transcript_id_out_2.txt'
 
APPEND
 
INTO TABLE AR_Refseq_transcripts_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Refseq_transcripts_ID,
genechip_array)
