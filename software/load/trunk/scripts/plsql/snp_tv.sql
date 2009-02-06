CREATE OR REPLACE procedure snp_TV_LD as

  CURSOR DATABASECROSSCUR IS
  (select rownum,
  a.DBSNP_RS_ID		DBSNP_RS_ID,
  a.ALLELE_A		ALLELE_A,
  a.ALLELE_B		ALLELE_B,
  a.VALIDATION_STATUS	VALIDATION_STATUS,
  b.CHROMOSOME_ID	CHROMOSOME_ID
	FROM ZSTG_SNP_NCBI a, chromosome b
	where b.taxon_ID = 5 and 
	a.chromosome_number = b.chromosome_number);

  aID number:=0;

BEGIN

  EXECUTE IMMEDIATE('TRUNCATE TABLE SNP_TV REUSE STORAGE');

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

  INSERT INTO SNP_TV (
  ID,
  DB_SNP_ID,
  VALIDATION_STATUS,
  CHROMOSOME_ID,
  ALLELE_A,
  ALLELE_B)
      VALUES
     (aRec.ROWNUM,
      aRec.DBSNP_RS_ID,
      aRec.VALIDATION_STATUS,
      aRec.CHROMOSOME_ID,
      aRec.ALLELE_A,
      aRec.ALLELE_B);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END;
/