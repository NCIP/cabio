CREATE OR REPLACE procedure CYTOGENIC_L_CYTOBAND_04_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (select rownum, c.chromosome_id chromosome_id, b.id start_cytoband_loc_id
	from cytoband_mouse_tran a, cytoband b, chromosome c
	where a.cytoband = b.name and substr(a.chrom, 4) = c.chromosome_number and c.taxon_id = 6);

  aID number:=0;

BEGIN

   SELECT MAX(CYTOGENIC_LOCATION_ID) INTO V_MAXROW FROM CYTOGENIC_LOCATION_CYTOBAND;

   FOR aRec in PHYCUR LOOP
      aID := aID + 1;

      insert into CYTOGENIC_LOCATION_CYTOBAND (
		CYTOGENIC_LOCATION_ID, chromosome_ID, START_CYTOBAND_LOC_ID)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.chromosome_id,
	aRec.START_CYTOBAND_LOC_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

