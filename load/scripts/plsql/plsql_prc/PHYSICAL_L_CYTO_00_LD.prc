CREATE OR REPLACE PROCEDURE PHYSICAL_L_CYTO_00_LD
IS
   CURSOR cyto_cur
   IS
      SELECT rownum, cb_start, cb_end_pos, chr_cytoband, chromosome_ID from
        (Select cp.cb_start cb_start, cp.cb_end_pos cb_end_pos,
		cp.chr_cytoband chr_cytoband, c.chromosome_ID chromosome_ID
	FROM cytoband_position cp, chromosome c
	where cp.chromosome = c.chromosome_number and c.Taxon_ID = 5);

  aID number:=0;

BEGIN

	EXECUTE IMMEDIATE('TRUNCATE TABLE PHYSICAL_LOCATION REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE CYTOBAND REUSE STORAGE ');

   FOR erec IN cyto_cur LOOP

      aID := aID + 1;

      INSERT INTO physical_location
                  (ID, chromosomal_start_position, chromosomal_end_position, chromosome_ID
                  )
           VALUES (erec.rownum, erec.cb_start, erec.cb_end_pos, erec.chromosome_ID
                  );

      INSERT INTO cytoband
                  (ID, NAME, physical_location_id
                  )
           VALUES (erec.rownum, erec.chr_cytoband, erec.rownum
                  );

      IF MOD (aID, 500) = 0
      THEN
         COMMIT;
      END IF;
   END LOOP;

   COMMIT;
END; 
/

