LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/refseq_transcript_id_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/refseq_transcript_id_out_2.txt'
 
APPEND
 
INTO TABLE AR_Refseq_transcripts_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Refseq_transcripts_ID,
genechip_array)
