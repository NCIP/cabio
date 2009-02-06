LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/cgdc/MissingDiseaseOntologyEVSIds.dat'
 
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
