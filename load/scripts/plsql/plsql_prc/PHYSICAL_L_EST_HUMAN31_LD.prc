CREATE OR REPLACE procedure PHYSICAL_L_EST_HUMAN31_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (select ROWNUM, a.id nucleic_acid_id, b.chromosome_id chromosome_id,
	c.tstart chromosomal_start_position, c.tend chromosomal_end_position
	from nucleic_acid_sequence a, chromosome b, all_est_human_stg_5162005 c
	where a.accession_number = c.qname AND SUBSTR (c.tname, 4) = b.chromosome_number AND b.taxon_id = 5);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM PHYSICAL_LOCATION;

   FOR aRec in PHYCUR LOOP
      aID := aID + 1;

      INSERT INTO PHYSICAL_LOCATION(ID,
                          nucleic_acid_id,
                          chromosome_id,
                          chromosomal_start_position,
                          chromosomal_end_position)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.nucleic_acid_id,
      aRec.chromosome_id,
      aRec.chromosomal_start_position,
      aRec.chromosomal_end_position);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

