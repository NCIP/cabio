CREATE OR REPLACE procedure snp_TV_update_dk_LD as

  V_MAXROW NUMBER :=0;

  CURSOR DATABASECROSSCUR IS
  (select rownum,
  a.DBSNP_RS_ID		DBSNP_RS_ID,
  a.ALLELE_A		ALLELE_A,
  a.ALLELE_B		ALLELE_B,
  b.CHROMOSOME_ID	CHROMOSOME_ID
	FROM ZSTG_SNP_AFFY a, chromosome b
	where b.taxon_ID = 5 and a.chromosome = b.chromosome_number);

  aID number:=0;

  V_SNP_TV Varchar2(100);

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM SNP_TV_dk;

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

 select DB_SNP_ID into V_SNP_TV from SNP_TV_dk where DB_SNP_ID = aRec.DBSNP_RS_ID;

 	IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

EXCEPTION
WHEN NO_DATA_FOUND THEN

      INSERT INTO SNP_TV_DK (
  ID,
  DB_SNP_ID,
  CHROMOSOME_ID,
  ALLELE_A,
  ALLELE_B)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.DBSNP_RS_ID,
      aRec.CHROMOSOME_ID,
      aRec.ALLELE_A,
      aRec.ALLELE_B);

END; 
/

