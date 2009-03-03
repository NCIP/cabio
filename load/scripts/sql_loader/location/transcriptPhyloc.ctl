LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/transcript/phylocTranscript.txt'
 
APPEND
 
INTO TABLE physical_location 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( transcriptID filler,
  chromosomeID filler,
  CHROM_START_POSITION filler,
  transcript_ID,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  ID SEQUENCE(MAX,1)
)

INTO TABLE location_tv 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( 
  transcriptID filler POSITION(1),
  chromosomeID filler,
  CHROM_START_POSITION filler,
  transcript_ID,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION filler,
  CHROMOSOMAL_END_POSITION filler,
  ID SEQUENCE(MAX,1)
)


INTO TABLE location_ch 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( 
  transcriptID filler POSITION(1),
  chromosomeID filler,
  CHROM_START_POSITION filler,
  transcript_ID,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  DISCRIMINATOR CONSTANT "TranscriptPhysicalLocation",
  FEATURE_TYPE CONSTANT "transcript",
  ASSEMBLY CONSTANT "reference",	
  ID SEQUENCE(MAX,1)
)
