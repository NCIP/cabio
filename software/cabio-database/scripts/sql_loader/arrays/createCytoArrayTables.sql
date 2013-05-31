/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

DROP TABLE zstg_startexprarrayrepcytoids;
DROP TABLE zstg_endexprarrayrepcytoids;
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
column columnload new_value load_tablspc;
select globals.get_load_tablespace as columnload from dual;
CREATE TABLE zstg_startexprarrayrepcytoids TABLESPace &load_tablspc AS SELECT 
                DISTINCT A.ID, A.CYTO_START, B.ID AS cytobandID, A.chromosome_ID
                                     FROM zstg_expression_reporter A, cytoband B
   WHERE TRIM(LOWER(A.CYTO_START)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                      B.chromosome_ID AND TRIM(LOWER(A.CYTO_START)) IS NOT NULL;

CREATE TABLE zstg_endexprarrayrepcytoids TABLESPace &load_tablspc AS SELECT DISTINCT 
                          A.ID, A.CYTO_STOP, B.ID AS cytobandID, A.chromosome_ID
                                     FROM zstg_expression_reporter A, cytoband B
    WHERE TRIM(LOWER(A.CYTO_STOP)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;


CREATE INDEX STARTA1 ON zstg_startexprarrayrepcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX STARTA2 ON zstg_startexprarrayrepcytoids(CYTO_START) TABLESPace 
&load_tablspc;
CREATE INDEX STARTA3 ON zstg_startexprarrayrepcytoids(cytobandID) TABLESPace 
&load_tablspc;
CREATE INDEX STARTA4 ON zstg_startexprarrayrepcytoids(chromosome_ID) TABLESPace 
&load_tablspc;
CREATE INDEX ENDA1 ON zstg_endexprarrayrepcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX ENDA2 ON zstg_endexprarrayrepcytoids(CYTO_STOP) TABLESPace &load_tablspc
;
CREATE INDEX ENDA3 ON zstg_endexprarrayrepcytoids(cytobandID) TABLESPace 
&load_tablspc;
CREATE INDEX ENDA4 ON zstg_endexprarrayrepcytoids(chromosome_ID) TABLESPace 
&load_tablspc;

DROP TABLE zstg_startsnparrayrepcytoids;
DROP TABLE zstg_endsnparrayrepcytoids;

CREATE TABLE zstg_startsnparrayrepcytoids TABLESPace &load_tablspc AS SELECT DISTINCT 
                         A.ID, A.CYTO_START, B.ID AS cytobandID, A.chromosome_ID
                                            FROM zstg_snp_reporter A, cytoband B
   WHERE TRIM(LOWER(A.CYTO_START)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;

CREATE TABLE zstg_endsnparrayrepcytoids TABLESPace &load_tablspc AS SELECT DISTINCT 
                          A.ID, A.CYTO_STOP, B.ID AS cytobandID, A.chromosome_ID
                                            FROM zstg_snp_reporter A, cytoband B
    WHERE TRIM(LOWER(A.CYTO_STOP)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID =
                                                                B.chromosome_ID;

CREATE INDEX STARTS1 ON zstg_startsnparrayrepcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX STARTS2 ON zstg_startsnparrayrepcytoids(CYTO_START) TABLESPace 
&load_tablspc;
CREATE INDEX STARTS3 ON zstg_startsnparrayrepcytoids(cytobandID) TABLESPace 
&load_tablspc;
CREATE INDEX STARTS4 ON zstg_startsnparrayrepcytoids(chromosome_ID) TABLESPace 
&load_tablspc;
CREATE INDEX ENDS1 ON zstg_endsnparrayrepcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX ENDS2 ON zstg_endsnparrayrepcytoids(CYTO_STOP) TABLESPace &load_tablspc;
CREATE INDEX ENDS3 ON zstg_endsnparrayrepcytoids(cytobandID) TABLESPace &load_tablspc
;
CREATE INDEX ENDS4 ON zstg_endsnparrayrepcytoids(chromosome_ID) TABLESPace 
&load_tablspc;

