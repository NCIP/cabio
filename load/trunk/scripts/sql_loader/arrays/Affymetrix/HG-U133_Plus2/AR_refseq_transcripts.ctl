LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/refseq_transcript_id_out.txt'
 
APPEND
 
INTO TABLE AR_Refseq_transcripts
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Refseq_transcripts_ID,
genechip_array)
