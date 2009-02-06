CREATE OR REPLACE procedure CYTO_L_CYTOBAND31_02_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (select rownum, a.gene_id gene_ID, b.ID ID from gene_stg31 a, 
  cytoband b
	where a.cytoband = b.name);

  aID number:=0;

BEGIN

   SELECT MAX(CYTOGENIC_LOCATION_ID) INTO V_MAXROW FROM CYTOGENIC_LOCATION_CYTOBAND;

   FOR aRec in PHYCUR LOOP
      aID := aID + 1;

      insert into CYTOGENIC_LOCATION_CYTOBAND (
		CYTOGENIC_LOCATION_ID, gene_ID, START_CYTOBAND_LOC_ID)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.gene_id,
	aRec.ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

