CREATE OR REPLACE procedure DATABASE_CROSS_REF31_04_LD as

  V_MAXROW NUMBER :=0;

  CURSOR DATABASECROSSCUR IS
  	(SELECT rownum, a.ID ID, b.tsc_id tsc_id
             FROM snp_tv a, snp_tsc_rs b
            WHERE a.db_snp_id = b.dbsnp_RS_id);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM DATABASE_CROSS_REFERENCE;

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

      INSERT INTO DATABASE_CROSS_REFERENCE(ID,
                          snp_ID,
                          TYPE,
                          SOURCE_NAME,
                          CROSS_REFERENCE_ID,
                          SOURCE_TYPE)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.ID,
      'gov.nih.nci.cabio.domain.SNP',
      'SNP',
      aRec.tsc_id,
      'SNP Consortium');

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

