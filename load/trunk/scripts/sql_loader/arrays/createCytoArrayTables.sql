DROP TABLE zstg_startexprarrayrepcytoids;
DROP TABLE zstg_endexprarrayrepcytoids;

CREATE TABLE zstg_startexprarrayrepcytoids TABLESPace cabio_map_fut AS SELECT 
                DISTINCT A.ID, A.CYTO_START, B.ID AS cytobandID, A.chromosome_ID
                                     FROM zstg_expression_reporter A, cytoband B
   WHERE TRIM(LOWER(A.CYTO_START)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                      B.chromosome_ID AND TRIM(LOWER(A.CYTO_START)) IS NOT NULL;

CREATE TABLE zstg_endexprarrayrepcytoids TABLESPace cabio_map_fut AS SELECT DISTINCT 
                          A.ID, A.CYTO_STOP, B.ID AS cytobandID, A.chromosome_ID
                                     FROM zstg_expression_reporter A, cytoband B
    WHERE TRIM(LOWER(A.CYTO_STOP)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;


CREATE INDEX STARTA1 ON zstg_startexprarrayrepcytoids(ID) TABLESPace cabio_map_fut;
CREATE INDEX STARTA2 ON zstg_startexprarrayrepcytoids(CYTO_START) TABLESPace 
cabio_map_fut;
CREATE INDEX STARTA3 ON zstg_startexprarrayrepcytoids(cytobandID) TABLESPace 
cabio_map_fut;
CREATE INDEX STARTA4 ON zstg_startexprarrayrepcytoids(chromosome_ID) TABLESPace 
cabio_map_fut;
CREATE INDEX ENDA1 ON zstg_endexprarrayrepcytoids(ID) TABLESPace cabio_map_fut;
CREATE INDEX ENDA2 ON zstg_endexprarrayrepcytoids(CYTO_STOP) TABLESPace cabio_map_fut
;
CREATE INDEX ENDA3 ON zstg_endexprarrayrepcytoids(cytobandID) TABLESPace 
cabio_map_fut;
CREATE INDEX ENDA4 ON zstg_endexprarrayrepcytoids(chromosome_ID) TABLESPace 
cabio_map_fut;

DROP TABLE zstg_startsnparrayrepcytoids;
DROP TABLE zstg_endsnparrayrepcytoids;

CREATE TABLE zstg_startsnparrayrepcytoids TABLESPace cabio_map_fut AS SELECT DISTINCT 
                         A.ID, A.CYTO_START, B.ID AS cytobandID, A.chromosome_ID
                                            FROM zstg_snp_reporter A, cytoband B
   WHERE TRIM(LOWER(A.CYTO_START)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;

CREATE TABLE zstg_endsnparrayrepcytoids TABLESPace cabio_map_fut AS SELECT DISTINCT 
                          A.ID, A.CYTO_STOP, B.ID AS cytobandID, A.chromosome_ID
                                            FROM zstg_snp_reporter A, cytoband B
    WHERE TRIM(LOWER(A.CYTO_STOP)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;

CREATE INDEX STARTS1 ON zstg_startsnparrayrepcytoids(ID) TABLESPace cabio_map_fut;
CREATE INDEX STARTS2 ON zstg_startsnparrayrepcytoids(CYTO_START) TABLESPace 
cabio_map_fut;
CREATE INDEX STARTS3 ON zstg_startsnparrayrepcytoids(cytobandID) TABLESPace 
cabio_map_fut;
CREATE INDEX STARTS4 ON zstg_startsnparrayrepcytoids(chromosome_ID) TABLESPace 
cabio_map_fut;
CREATE INDEX ENDS1 ON zstg_endsnparrayrepcytoids(ID) TABLESPace cabio_map_fut;
CREATE INDEX ENDS2 ON zstg_endsnparrayrepcytoids(CYTO_STOP) TABLESPace cabio_map_fut;
CREATE INDEX ENDS3 ON zstg_endsnparrayrepcytoids(cytobandID) TABLESPace cabio_map_fut
;
CREATE INDEX ENDS4 ON zstg_endsnparrayrepcytoids(chromosome_ID) TABLESPace 
cabio_map_fut;

