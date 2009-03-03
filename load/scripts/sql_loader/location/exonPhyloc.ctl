LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/exon/phylocExon.txt'
 
APPEND
 
INTO TABLE physical_location 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( exonREPID filler,
  CHRID filler,
  STARTPOS filler,
  exon_reporter_ID, 
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  ID SEQUENCE(MAX,1)
)

INTO TABLE location_tv 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( exonREPID filler POSITION(1),
  CHRID filler,
  STARTPOS filler,
  exon_reporter_ID,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION filler,
  CHROMOSOMAL_END_POSITION filler,
  ID SEQUENCE(MAX,1)
)
