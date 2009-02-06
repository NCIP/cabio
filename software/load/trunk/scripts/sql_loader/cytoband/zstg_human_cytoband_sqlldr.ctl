LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cytoband/human_cytoband.txt'
 
APPEND
 
INTO TABLE zstg_human_cytoband
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
