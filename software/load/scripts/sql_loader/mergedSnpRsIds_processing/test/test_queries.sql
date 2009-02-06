-- Should return 0 rows
-- Get those rows from SNP REPORTER THAT have NULL SNP ID 
-- and are present in SNP AFFY and have a mapping to MERGED SNP IDs table
-- if merged mapping happened successfully, then results are 0
select count(distinct ID) from snp_reporter A, zstg_snp_affy B,
zstg_merged_snp_rsids_mapping C 
where A.SNP_ID is NULL and 
A.NAME = B.PROBE_SET_ID and trim(B.DBSNP_RS_ID) = trim(C.OLD_RS_ID)

-- Should return 0 rows
-- Get those rows from SNP REPORTER THAT have NULL SNP ID 
-- and are present in SNP ILLUMINA and have a mapping to MERGED SNP IDs table
-- if merged mapping happened successfully, then results are 0
select count(*) from
snp_reporter A, zstg_snp_illumina B, zstg_merged_snp_rsids_mapping C
where
A.SNP_ID is NULL and
trim(A.NAME) = trim(B.DBSNP_RS_ID) and
trim(B.DBSNP_RS_ID) = trim(C.OLD_RS_ID);
exit;
