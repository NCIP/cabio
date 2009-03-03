LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cytoband/mouse_cytoband.txt'
 
APPEND
 
INTO TABLE zstg_mouse_cytoband
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
 
( CHROM,
  CHROMSTART,
  CHROMEND,
  CYTONAME,
  STAIN,
  chromosome_NO,
  chromosome_ID,
  cytoband "lower(trim(:cytoband))",
  ID SEQUENCE(MAX, 1) 
)
