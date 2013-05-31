/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

set feedback on;
set termout on;
set verify on;
set echo on;
@$LOAD/indexes/zstg_human_cytoband.cols.sql;
@$LOAD/indexes/zstg_mouse_cytoband.cols.sql;
@$LOAD/indexes/zstg_map.cols.sql;

@$LOAD/constraints/zstg_human_cytoband.enable.sql;
@$LOAD/constraints/zstg_mouse_cytoband.enable.sql;

@$LOAD/triggers/zstg_human_cytoband.enable.sql;
@$LOAD/triggers/zstg_mouse_cytoband.enable.sql;

@$LOAD/triggers/cytoband.enable.sql;
VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

DROP SEQUENCE cytoband_ID_SEQ;
CREATE SEQUENCE cytoband_ID_SEQ START WITH 1 INCREMENT BY 1;
ALTER TRIGGER SET_cytoband_ID ENABLE;

DROP SEQUENCE cytoband_PHYLOC_ID;
CREATE SEQUENCE cytoband_PHYLOC_ID START WITH 1 INCREMENT BY 1;
ALTER TRIGGER SET_CYTO_PHYLOC_ID ENABLE;

---because UCSC database using 0-sart and 1-end coordinates 
update  zstg_human_cytoband set chromstart = chromstart + 1;
commit;

update  zstg_mouse_cytoband set chromstart = chromstart + 1;
commit; 

INSERT
 INTO cytoband(NAME, chromosome_ID) SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM 
zstg_human_cytoband
                                      WHERE chromosome_ID IS NOT NULL;

INSERT
  INTO cytoband(NAME, chromosome_ID)SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM 
zstg_mouse_cytoband
                                     WHERE chromosome_ID IS NOT NULL;

ALTER TRIGGER SET_CYTO_PHYLOC_ID DISABLE;
INSERT
  INTO zstg_map(MAP_ID, cytoband, MAP_LOCATION, chromosome_NUMBER, MAP_TYPE, 
taxon_ID, chromosome_ID) SELECT DISTINCT ROWNUM, cytoband, MAP_LOCATION, 
chromosome_NUMBER, MAP_TYPE, taxon_ID, CHROMOSOME_ID FROM (SELECT DISTINCT 
cytoband, DECODE(INSTR(CYTOBAND, '|'), 0, DECODE(INSTR(CYTOBAND, '-'), 0, 
cytoband, SUBSTR(CYTOBAND, 0, INSTR(CYTOBAND, '-') - 1)), SUBSTR(CYTOBAND, 0, 
INSTR(cytoband, '|') - 1)) AS MAP_LOCATION, DECODE(INSTR(CYTOBAND, 'p'), 0, 
SUBSTR(cytoband, 0, INSTR(CYTOBAND, 'q') - 1), SUBSTR(CYTOBAND, 0, INSTR(
cytoband, 'p') - 1)) AS chromosome_NUMBER, 'C' AS MAP_TYPE, C.taxon_ID, 
C.chromosome_ID FROM CGAP.HS_CLUSTER@WEB.NCI.NIH.GOV A, zstg_gene_identifiers B, 
gene_tv C
  WHERE (A.cytoband LIKE '%p%' OR A.CYTOBAND LIKE '%q%') AND A.CYTOBAND NOT LIKE 
'%-%|%' AND A.LOCUSLINK = B.IDENTIFIER AND B.data_source = 2 AND B.gene_ID = 
C.gene_ID UNION SELECT DISTINCT cytoband, DECODE(INSTR(CYTOBAND, '|'), 0, DECODE
(INSTR(cytoband, '-'), 0, CYTOBAND, DECODE(INSTR(CYTOBAND, 'p'), 0, SUBSTR(
cytoband, 0, INSTR(CYTOBAND, 'q') - 1), SUBSTR(CYTOBAND, 0, INSTR(CYTOBAND, 'p') 
- 1)) || SUBSTR(cytoband, INSTR(CYTOBAND, '-') + 1)), DECODE(INSTR(CYTOBAND, 'p'
), 0, SUBSTR(cytoband, 0, INSTR(CYTOBAND, 'q') - 1), SUBSTR(CYTOBAND, 0, INSTR(
cytoband, 'p') - 1)) || SUBSTR(CYTOBAND, INSTR(CYTOBAND, '|') + 1)) AS 
MAP_LOCATION, DECODE(INSTR(cytoband, 'p'), 0, SUBSTR(CYTOBAND, 0, INSTR(CYTOBAND
, 'q') - 1), SUBSTR(cytoband, 0, INSTR(CYTOBAND, 'p') - 1)) AS chromosome_NUMBER
, 'C' AS MAP_TYPE, C.taxon_ID, C.chromosome_ID FROM CGAP.MM_CLUSTER@
WEB.NCI.NIH.GOV A, zstg_gene_identifiers B, gene_tv C
  WHERE (A.cytoband LIKE '%p%' OR A.CYTOBAND LIKE '%q%') AND A.CYTOBAND NOT LIKE 
'%-%|%' AND A.LOCUSLINK = B.IDENTIFIER AND B.data_source = 2 AND B.gene_ID = 
C.gene_ID);
COMMIT;

UPDATE zstg_map SET END_cytoband = chromosome_NUMBER || SUBSTR(MAP_LOCATION, 
INSTR(MAP_LOCATION, '-') + 1)
 WHERE INSTR(MAP_LOCATION, '-') > 0;

UPDATE zstg_map SET START_cytoband = SUBSTR(MAP_LOCATION, 0, INSTR(MAP_LOCATION
, '-') - 1)
 WHERE INSTR(MAP_LOCATION, '-') > 0;

UPDATE zstg_map SET END_cytoband = chromosome_NUMBER || SUBSTR(MAP_LOCATION, 
INSTR(MAP_LOCATION, '|') + 1)
 WHERE INSTR(MAP_LOCATION, '|') > 0;

UPDATE zstg_map SET START_cytoband = SUBSTR(MAP_LOCATION, 0, INSTR(MAP_LOCATION
, '|') - 1)
 WHERE INSTR(MAP_LOCATION, '|') > 0;

UPDATE zstg_map SET END_cytoband = MAP_LOCATION
 WHERE ((INSTR(MAP_LOCATION, '-')) = 0 AND (INSTR(MAP_LOCATION, '|')) = 0) ;

UPDATE zstg_map SET START_cytoband = MAP_LOCATION
 WHERE ((INSTR(MAP_LOCATION, '-')) = 0 AND (INSTR(MAP_LOCATION, '|')) = 0) ;

COMMIT;
delete from zstg_map where start_cytoband is null or end_cytoband is null;
commit;

@$LOAD/constraints/zstg_map.enable.sql;

INSERT
INTO cytoband(NAME, chromosome_ID)SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM (
SELECT DISTINCT TRIM(LOWER(START_cytoband)) CYTOBAND, chromosome_ID FROM 
zstg_map
 WHERE START_cytoband IS NOT NULL MINUS SELECT TRIM(LOWER(NAME)) CYTOBAND, 
chromosome_ID FROM cytoband);
COMMIT;

INSERT
INTO cytoband(NAME, chromosome_ID)SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM (
SELECT DISTINCT TRIM(LOWER(END_cytoband)) CYTOBAND, chromosome_ID FROM zstg_map
 WHERE END_cytoband IS NOT NULL MINUS SELECT TRIM(LOWER(NAME)) CYTOBAND, 
chromosome_ID FROM cytoband);
COMMIT;

INSERT
 INTO cytoband (NAME, chromosome_ID)SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM 
(SELECT TRIM(LOWER(cytoband)) CYTOBAND, B.chromosome_ID FROM zstg_snp_affy A, 
chromosome B
  WHERE cytoband IS NOT NULL AND TRIM(A.chromosome) = TRIM(B.CHROMOSOME_NUMBER) 
AND A.cytoband <> '---' AND A.chromosome <> 'Chromosome' MINUS SELECT TRIM(
LOWER(NAME)), chromosome_ID cytoband FROM CYTOBAND);
COMMIT;



INSERT
 INTO cytoband (NAME, chromosome_ID)SELECT DISTINCT CYTOBAND, CHROMOSOME_ID FROM 
(SELECT TRIM(LOWER(CYTO_START)) cytoband, B.chromosome_ID FROM 
ar_chromosomal_location A, chromosome B
  WHERE CYTO_START IS NOT NULL AND TRIM(A.TRIM_CHR) = TRIM(B.chromosome_NUMBER) 
AND A.CYTO_START <> '.' AND B.taxon_ID = 5 UNION SELECT TRIM(LOWER(CYTO_STOP)) 
cytoband, B.chromosome_ID FROM ar_chromosomal_location A, CHROMOSOME B
   WHERE CYTO_STOP IS NOT NULL AND TRIM(A.TRIM_CHR) = TRIM(B.chromosome_NUMBER) 
AND A.CYTO_STOP <> '.' AND B.taxon_ID = 5 UNION SELECT TRIM(LOWER(CYTO_START)) 
cytoband, B.chromosome_ID FROM ar_chromosomal_location_tmp A, CHROMOSOME B
  WHERE CYTO_START IS NOT NULL AND TRIM(A.TRIM_CHR) = TRIM(B.chromosome_NUMBER) 
AND A.CYTO_START <> '.' AND B.taxon_ID = 5 UNION SELECT TRIM(LOWER(CYTO_STOP)) 
cytoband, B.chromosome_ID FROM ar_chromosomal_location_tmp A, CHROMOSOME B
   WHERE CYTO_STOP IS NOT NULL AND TRIM(A.TRIM_CHR) = TRIM(B.chromosome_NUMBER) 
AND A.CYTO_STOP <> '.' AND B.taxon_ID = 5 MINUS SELECT TRIM(LOWER(NAME)), 
chromosome_ID cytoband FROM CYTOBAND);
COMMIT;

INSERT
INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT TRIM(LOWER(START_CYTOBAND)), chromosome_ID FROM zstg_gene WHERE START_cytoband IS NOT NULL and start_cytoband not like '% %' MINUS SELECT TRIM(LOWER(NAME)), chromosome_ID cytoband FROM CYTOBAND; 
COMMIT;

INSERT
  INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT TRIM(LOWER(END_CYTOBAND)), chromosome_ID FROM zstg_gene where end_cytoband not like '% %' and END_cytoband IS NOT NULL MINUS SELECT TRIM(LOWER(NAME)), chromosome_ID cytoband FROM CYTOBAND; 
COMMIT;

INSERT
  INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT TRIM(LOWER(CYTO_START)), chromosome_ID FROM zstg_rna_agilent A, CHROMOSOME B WHERE A.CYTO_START IS NOT NULL AND A.chromosome_NUMBER = B.CHROMOSOME_NUMBER 
AND B.taxon_ID = 5 MINUS SELECT TRIM(LOWER(NAME)) cytoband, chromosome_ID FROM 
cytoband; 
COMMIT;

INSERT
  INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT TRIM(LOWER(CYTO_STOP)), 
chromosome_ID FROM zstg_rna_agilent A, CHROMOSOME B
WHERE A.CYTO_STOP IS NOT NULL AND A.chromosome_NUMBER = B.CHROMOSOME_NUMBER AND 
B.taxon_ID = 5 MINUS SELECT TRIM(LOWER(NAME)) cytoband, chromosome_ID FROM 
cytoband; 
COMMIT;

INSERT
 INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT C.CYTOBAND, G.CHROMOSOME_ID 
           FROM (SELECT TRIM(LOWER(START_cytoband)) CYTOBAND FROM zstg_clone_dim
   WHERE START_cytoband IS NOT NULL  and start_cytoband not like '% %' MINUS SELECT TRIM(LOWER(NAME)) CYTOBAND FROM 
cytoband) C, gene_tv G, zstg_clone_dim Z
WHERE C.cytoband = Z.CYTOBAND AND SUBSTR(Z.UNIgene_ID, INSTR(Z.UNIGENE_ID, '.') 
+ 1) = G.CLUSTER_ID; 
COMMIT;

INSERT
 INTO cytoband (NAME, chromosome_ID) SELECT DISTINCT C.CYTOBAND, G.CHROMOSOME_ID 
             FROM (SELECT TRIM(LOWER(END_cytoband)) CYTOBAND FROM zstg_clone_dim
     WHERE END_cytoband IS NOT NULL and end_cytoband not like '% %' MINUS SELECT TRIM(LOWER(NAME)) CYTOBAND FROM 
cytoband) C, gene_tv G, zstg_clone_dim Z
WHERE C.cytoband = Z.CYTOBAND AND SUBSTR(Z.UNIgene_ID, INSTR(Z.UNIGENE_ID, '.') 
+ 1) = G.CLUSTER_ID; 
COMMIT;

DELETE FROM cytoband WHERE NAME like '%-%';
DELETE FROM cytoband WHERE NAME = '3';
COMMIT;


@$LOAD/indexes/cytoband.cols.sql;
@$LOAD/indexes/cytoband.lower.sql;
@$LOAD/constraints/cytoband.enable.sql;
@$LOAD/triggers/cytoband.disable.sql;

ANALYZE TABLE cytoband COMPUTE STATISTICS;

COMMIT;
EXIT; 

