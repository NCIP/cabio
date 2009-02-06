-- Processing for Merged Snp Tables
-- Add indexes on ZSTG_MERGEDSNPRSIDS_MAPPING table
@$LOAD/indexer_new.sql zstg_merged_snp_rsids_mapping
@$LOAD/indexes/zstg_merged_snp_rsids_mapping.cols.sql
@$LOAD/indexes/zstg_merged_snp_rsids_mapping.lower.sql

-- Add primary key constraint on ZSTG_MERGED SNP Rs Ids table on OLD_RS_ID
--ALTER TABLE zstg_merged_snp_rsids_mapping add constraint ZSTG_MERGED_SNP_RSIDS_MAP_PK primary key("OLD_RS_ID"); 


-- Create temporary table zstg_snprep_sntv_ids_mpng that maps the DBSNPRSIds and SNPTVIds 

Analyze table zstg_merged_snp_rsids_mapping compute statistics;
Analyze table zstg_snp_affy compute statistics;
Analyze table snp_reporter compute statistics;
Analyze table zstg_snp_illumina compute statistics;
DROP TABLE TMP_MERGEDIDS;
CREATE TABLE TMP_MERGEDIDS AS SELECT DISTINCT A.ID, CURRENT_RS_ID
      FROM array_reporter_ch A, zstg_snp_affy C, zstg_merged_snp_rsids_mapping D
   WHERE A.SNP_ID IS NULL AND LOWER(TRIM(A.NAME)) = LOWER(TRIM(C.PROBE_SET_ID)) 
                     AND LOWER(TRIM(C.DBSNP_RS_ID)) = LOWER(TRIM(D.OLD_RS_ID)); 
COMMIT;
SELECT COUNT(*)
  FROM TMP_MERGEDIDS;

INSERT
  INTO TMP_MERGEDIDS SELECT DISTINCT A.ID, CURRENT_RS_ID
  FROM array_reporter_ch A, zstg_snp_illumina C, zstg_merged_snp_rsids_mapping D
                      WHERE
                    A.SNP_ID IS NULL AND TRIM(A.NAME) = TRIM(C.DBSNP_RS_ID) AND
                            TRIM(C.DBSNP_RS_ID) = TRIM(D.OLD_RS_ID);
COMMIT;
SELECT COUNT(*)
  FROM TMP_MERGEDIDS;

TRUNCATE TABLE zstg_snprep_sntv_ids_mpng;

INSERT
  INTO zstg_snprep_sntv_ids_mpng SELECT DISTINCT A.ID, B.ID
                                   FROM TMP_MERGEDIDS A, snp_tv B
                                  WHERE A.CURRENT_RS_ID = B.DB_SNP_ID;
COMMIT;
SELECT COUNT(*)
  FROM zstg_snprep_sntv_ids_mpng;

-- Add data from Illumina tables into this table


-- Find those SNP REPORTER Ids that occur twice 
-- delete those from this mapping table
-- If bug about duplicate SNP Ids has been resolved properly, the following procedure is not needed
@deleteDupIds_MrgIdMapping.sql;

-- Run the procedure created above
EXECUTE deleteDupIds_MrgIdMapping; 

-- Add indexes to temporary table before performing the update
CREATE INDEX ZSTG_MRGIDMAP_SNPREPID ON zstg_snprep_sntv_ids_mpng(SNPREPID);
CREATE INDEX ZSTG_MRGIDMAP_SNPTVID ON zstg_snprep_sntv_ids_mpng(ID);

ANALYZE TABLE zstg_snprep_sntv_ids_mpng COMPUTE STATISTICS;
---Update SNP Reporter table
UPDATE snp_reporter A SET A.SNP_ID =
(SELECT ID
   FROM zstg_snprep_sntv_ids_mpng
  WHERE SNPREPID = A.ID)
 WHERE A.SNP_ID IS NULL;
COMMIT;
UPDATE array_reporter_ch A SET A.SNP_ID =
(SELECT ID
   FROM zstg_snprep_sntv_ids_mpng
  WHERE SNPREPID = A.ID)
 WHERE A.SNP_ID IS NULL;
COMMIT;

-- Procedure and table dropped
DROP PROCEDURE DELETEDUPIDS_MRGIDMAPPING;
--DROP TABLE zstg_snprep_sntv_ids_mpng;
DROP TABLE TMP_MERGEDIDS;

EXIT;
