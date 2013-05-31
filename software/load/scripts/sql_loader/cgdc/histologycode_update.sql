/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

TRUNCATE TABLE histology_code REUSE STORAGE;

INSERT
  INTO histology_code (HISTOLOGY_code, HISTOLOGY_NAME, PARENT, concept_ID, 
RELATIONSHIP) SELECT histology_code, HISTOLOGY_NAME, PARENT, concept_ID, 
                     RELATIONSHIP
                FROM zstg_histology_code;

SELECT MAX(histology_code) + 1 AS V_MAXROW
  FROM histology_code; 

DROP SEQUENCE histology_code_ID_SEQ;
CREATE SEQUENCE histology_code_ID_SEQ START WITH &V_MAXROW INCREMENT BY 1;

MERGE
INTO histology_code H USING zstg_diseaseontology_cgid D ON (TRIM(
      H.HISTOLOGY_NAME) = TRIM(D.diseaseontology)) WHEN MATCHED THEN UPDATE SET 
  H.EVS_ID = D.EVS_ID WHEN NOT MATCHED THEN INSERT (histology_code, 
HISTOLOGY_NAME, EVS_ID) VALUES(histology_code_ID_SEQ.NEXTVAL, D.diseaseontology, 
                                                                      D.EVS_ID);
  
  UPDATE histology_code H SET EVS_ID = (SELECT MIN(EVS_ID)
                                          FROM zstg_missing_diseaseontol_cgid B
                                    WHERE B.diseaseontology = H.HISTOLOGY_NAME)
   WHERE EVS_ID IS NULL;
  @$LOAD/indexer_new.sql histology_code
  @$LOAD/indexes/histology_code.drop.sql
  @$LOAD/indexes/histology_code.cols.sql
  @$LOAD/indexes/histology_code.lower.sql
  COMMIT;
  EXIT;
  