CREATE OR REPLACE procedure PHYSICAL_L_SNP31_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (select ROWNUM, b.chromosome_id chromosome_id, a.physical_position physical_position, b.ID SNP_ID
	from snp_probeset_affy a, snp_tv b
	where a.dbsnp_rs_id = b.db_snp_id);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM PHYSICAL_LOCATION;

   FOR aRec in PHYCUR LOOP
      aID := aID + 1;

      INSERT INTO PHYSICAL_LOCATION(ID,
                          SNP_ID,
                          chromosome_id,
                          chromosomal_start_position,
                          chromosomal_end_position)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.SNP_id,
      aRec.chromosome_id,
      aRec.physical_position,
      aRec.physical_position);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

