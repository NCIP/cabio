VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

TRUNCATE TABLE cytogenic_location_cytoband REUSE STORAGE;
TRUNCATE TABLE CYTOGENIC_LOCATION REUSE STORAGE;

@$LOAD/indexer_new.sql cytogenic_location_cytoband;
@$LOAD/indexes/cytogenic_location_cytoband.drop.sql;

@$LOAD/indexer_new.sql CYTOGENIC_LOC_CBAND_REMOD;
@$LOAD/indexes/CYTOGENIC_LOC_CBAND_REMOD.drop.sql;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM physical_location; 
DROP SEQUENCE CYTO_LOC_CYTOID;

CREATE SEQUENCE CYTO_LOC_CYTOID START WITH &V_MAXROW INCREMENT BY 1;
ALTER TRIGGER CYTOGENIC_LOC_CYTOID ENABLE;

DROP SEQUENCE CYTO_LOC_CYTOID_REMOD;

CREATE SEQUENCE CYTO_LOC_CYTOID_REMOD START WITH &V_MAXROW INCREMENT BY 1;
ALTER TRIGGER CYTOGENIC_LOC_CYTOID_REMOD ENABLE;

-- SNP is linked to cytoband only in array data
-- SNP Cytogenetic Location
INSERT ALL 
  INTO cytogenic_location_cytoband (SNP_ID, START_cytoband_LOC_ID, 
END_cytoband_LOC_ID, chromosome_ID)
  INTO CYTOGENIC_LOCATION (SNP_ID, START_cytoband_LOC_ID, END_CYTOBAND_LOC_ID, 
chromosome_ID)
SELECT DISTINCT A.ID, E.ID, E.ID, A.chromosome_ID FROM snp_tv A, zstg_snp_affy C
, cytoband E
 WHERE A.DB_SNP_ID = C.DBSNP_RS_ID AND C.chromosome || C.cytoband = E.NAME;

COMMIT;

-- Gene Cytogenetic Location
INSERT ALL
  INTO cytogenic_location_cytoband (gene_ID, START_cytoband_LOC_ID, 
END_cytoband_LOC_ID, chromosome_ID) SELECT DISTINCT A.gene_ID, C.ID 
START_cytoband_LOC_ID, D.ID END_CYTOBAND_LOC_ID, A.chromosome_ID FROM zstg_gene 
A, zstg_startcytoids C, zstg_endcytoids D
 WHERE A.START_cytoband = C.START_CYTOBAND AND A.END_CYTOBAND = D.END_CYTOBAND 
AND A.chromosome_ID = C.CHROMOSOME_ID AND A.CHROMOSOME_ID = D.CHROMOSOME_ID; 

COMMIT;

-- Cytoband Cytogenetic Location
INSERT
  INTO cytogenic_location_cytoband (chromosome_ID, START_cytoband_LOC_ID, 
END_cytoband_LOC_ID) SELECT DISTINCT A.chromosome_ID CHROMOSOME_ID, B.ID 
START_cytoband_LOC_ID, B.ID END_CYTOBAND_LOC_ID FROM zstg_human_cytoband A, 
cytoband B
                      WHERE A.cytoband = B.NAME;
COMMIT;

INSERT
  INTO cytogenic_location_cytoband (chromosome_ID, START_cytoband_LOC_ID, 
END_cytoband_LOC_ID) SELECT DISTINCT A.chromosome_ID CHROMOSOME_ID, B.ID 
START_cytoband_LOC_ID, B.ID END_CYTOBAND_LOC_ID FROM zstg_mouse_cytoband A, 
cytoband B
                      WHERE A.cytoband = B.NAME;
COMMIT;

DROP SEQUENCE CYTO_LOC_CYTOID;
ALTER TRIGGER CYTOGENIC_LOC_CYTOID DISABLE;
@$LOAD/indexes/cytogenic_location_cytoband.cols.sql;
@$LOAD/indexes/cytogenic_location_cytoband.lower.sql;

DROP SEQUENCE CYTO_LOC_CYTOID_REMOD;
ALTER TRIGGER CYTOGENIC_LOC_CYTOID_REMOD DISABLE;
@$LOAD/indexes/CYTOGENIC_LOC_CBAND_REMOD.cols.sql;
@$LOAD/indexes/CYTOGENIC_LOC_CBAND_REMOD.lower.sql;
--ANALYZE TABLE cytogenic_location_cytoband COMPUTE STATISTICS;
EXIT; 
