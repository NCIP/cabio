-- update SNP with Affy data
UPDATE snp_tv S SET (FLANK, CHR_X_PSEUDO_AUTOSOMAL_REGION) =
        (SELECT Z.FLANK, Z.CHRX_PSEUDO_AUTOSOMAL_REGION
           FROM zstg_snp_affy Z
          WHERE Z.DBSNP_RS_ID = S.DB_SNP_ID
                AND ROWNUM = 1 and Z.CHRX_PSEUDO_AUTOSOMAL_REGION not like '%-%');
COMMIT;
-- update SNP with Illumina data
UPDATE snp_tv S SET (CODING_STATUS, AMINO_ACID_CHANGE) = (SELECT 
                                            Z.CODING_STATUS, Z.AMINO_ACID_CHANGE
                                                        FROM zstg_snp_illumina Z
                            WHERE Z.DBSNP_RS_ID = S.DB_SNP_ID AND ROWNUM = 1);
COMMIT;
