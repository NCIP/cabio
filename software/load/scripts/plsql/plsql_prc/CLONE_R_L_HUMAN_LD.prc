CREATE OR REPLACE procedure CLONE_R_L_HUMAN_LD as

 CURSOR CLONERLCUR IS
  (select ROWNUM, a.clone_id clone_id, b.id nucleic_acid_sequence_id, c.type type from
	clone a, nucleic_acid_sequence b, clone_r_l_human_stg_5162005 c
	where a.clone_name = c.clone_name AND a.clone_id = b.clone_id AND b.accession_number = c.accession_number);

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE CLONE_RELATIVE_LOCATION REUSE STORAGE ');

   FOR aRec in CLONERLCUR LOOP
      aID := aID + 1;

      INSERT INTO CLONE_RELATIVE_LOCATION(ID,
                          clone_id,
                          nucleic_acid_sequence_id,
                          type)
      VALUES
     (aRec.ROWNUM,
      aRec.clone_id,
      aRec.nucleic_acid_sequence_id,
      aRec.type);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

