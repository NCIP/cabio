LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/cgdc/MissingDiseaseOntologyEVSIds.dat'
 
APPEND
 
INTO TABLE zstg_missing_diseaseontol_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
diseaseontology,
MATCHING_concept,
EVS_ID
)
