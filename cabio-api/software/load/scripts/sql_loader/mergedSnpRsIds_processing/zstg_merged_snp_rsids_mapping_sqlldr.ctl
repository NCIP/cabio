LOAD DATA 
INFILE '$CABIO_DATA_DIR/mergedSNPids/RsMergeArch.bcp.out' 
BADFILE '$CABIO_DATA_DIR/mergedSNPids/RsMergeArch.bad'
DISCARDFILE '$CABIO_DATA_DIR/mergedSNPids/RsMergeArch.dsc'


INTO TABLE zstg_merged_snp_rsids_mapping


FIELDS TERMINATED BY "	"

  (OLD_RS_ID
, 
   NEW_RS_ID
, 
   BUILD_ID
, 
   ORIENTATION
, 
   CREATE_TIME
, 
   LAST_UPDATE_TIME
, 
   CURRENT_RS_ID
, 
   ORIEN2CURRENT
)

