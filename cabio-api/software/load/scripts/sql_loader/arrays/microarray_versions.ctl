LOAD DATA 
 
INFILE "$CABIO_DATA_DIR/temp/arrays/microarray_versions.txt"
 
APPEND
 
INTO TABLE zstg_microarray_versions

FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(array_name,
annotation_version
)
