--$markerHash{$id."|".$chrStart} = $id."|".$chrId."|".$chrStart."|".$chrStop."|".$fullName;
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/marker/phylocMarker.txt'
APPEND
 
INTO TABLE physical_location 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( 
  marker_ID POSITION(1),
  TAXID filler,
  CHRID filler,
  CHR_START_POSITION filler,
  marker_ID_AGAIN filler,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  UNISTS_markerID filler,
  ID SEQUENCE(MAX,1)
)

INTO TABLE location_ch 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( 
  marker_ID POSITION(1),
  TAXID filler,
  CHRID filler,
  CHR_START_POSITION filler,
  marker_ID_AGAIN filler,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  UNISTS_markerID filler,
  FEATURE_TYPE,
  ASSEMBLY,
  DISCRIMINATOR CONSTANT "MarkerPhysicalLocation",
  ID SEQUENCE(MAX,1)
)


INTO TABLE location_tv 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( 
  marker_ID POSITION(1),
  TAXID filler,
  CHRID filler,
  CHR_START_POSITION filler,
  marker_ID_AGAIN filler,
  chromosome_ID,
  CHROMOSOMAL_START_POSITION filler,
  CHROMOSOMAL_END_POSITION filler,
  UNISTS_markerID filler,
  ID SEQUENCE(MAX,1)
)

