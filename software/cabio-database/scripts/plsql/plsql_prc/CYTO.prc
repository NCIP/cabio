CREATE OR REPLACE PROCEDURE cyto
IS
   CURSOR cyto_cur
   IS
      SELECT cb_start, cb_end_pos, chr_cytoband
        FROM cytoband_position;

   pk_cnt        NUMBER;
   pk_cnt_cyto   NUMBER;
BEGIN
   SELECT NVL (MAX (ID), 0)
     INTO pk_cnt
     FROM physical_location;

   SELECT NVL (MAX (ID), 0)
     INTO pk_cnt_cyto
     FROM CYTOBAND;

   FOR erec IN cyto_cur
   LOOP
      pk_cnt := pk_cnt + 1;

      INSERT INTO physical_location
                  (ID, chromosomal_start_position, chromosomal_end_position
                  )
           VALUES (pk_cnt, erec.cb_start, erec.cb_end_pos
                  );

      pk_cnt_cyto := pk_cnt_cyto + 1;

      INSERT INTO cytoband
                  (ID, NAME, physical_location_id
                  )
           VALUES (pk_cnt_cyto, erec.chr_cytoband, pk_cnt
                  );

      IF MOD (pk_cnt, 100) = 0
      THEN
         COMMIT;
      END IF;
   END LOOP;

   COMMIT;
END; 
/

