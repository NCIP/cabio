CREATE OR REPLACE PROCEDURE PHYSICAL_L_CYTO_01_LD
IS

	  V_MAXROW_01 NUMBER :=0;
	  V_MAXROW_02 NUMBER :=0;

   CURSOR cyto_cur
   IS
       SELECT rownum, chromstart, chromend, cytoband, chromosome_ID from
        (Select cm.chromstart chromstart, cm.chromend chromend,
		cm.cytoband cytoband, c.chromosome_ID chromosome_ID
	FROM cytoband_mouse_tran cm, chromosome c
	where substr(chrom, 4) = c.chromosome_number and c.Taxon_ID = 6);

  aID number:=0;

BEGIN
	   SELECT MAX(ID) INTO V_MAXROW_01 FROM PHYSICAL_LOCATION;
	   SELECT MAX(ID) INTO V_MAXROW_02 FROM cytoband;


   FOR erec IN cyto_cur LOOP

      aID := aID + 1;

      INSERT INTO physical_location
                  (ID, chromosomal_start_position, chromosomal_end_position, chromosome_ID
                  )
           VALUES (erec.rownum + V_MAXROW_01 , erec.chromstart, erec.chromend, erec.chromosome_ID
                  );

      INSERT INTO cytoband
                  (ID, NAME, physical_location_id
                  )
           VALUES (erec.rownum + V_MAXROW_02, erec.cytoband, erec.rownum + V_MAXROW_01
                  );

      IF MOD (aID, 500) = 0
      THEN
         COMMIT;
      END IF;
   END LOOP;

   COMMIT;
END; 
/

