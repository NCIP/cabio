CREATE OR REPLACE procedure CLONE_R_L_MOUSE_LD as

  V_MAXROW NUMBER :=0;

 CURSOR CLONERLCUR IS
  (select ROWNUM, a.clone_id clone_id, b.id nucleic_acid_sequence_id, c.type type from
	clone a, nucleic_acid_sequence b, clone_r_l_MOUSE_stg_5162005 c
	where a.clone_name = c.clone_name AND a.clone_id = b.clone_id AND b.accession_number = c.accession_number);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM CLONE_RELATIVE_LOCATION;

   FOR aRec in CLONERLCUR LOOP
      aID := aID + 1;

      INSERT INTO CLONE_RELATIVE_LOCATION(ID,
                          clone_id,
                          nucleic_acid_sequence_id,
                          type)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
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

