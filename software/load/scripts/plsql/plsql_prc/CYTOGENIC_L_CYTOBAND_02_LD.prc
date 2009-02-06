CREATE OR REPLACE procedure CYTOGENIC_L_CYTOBAND_02_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (select rownum, gene_id, id from (
	Select a.gene_id, a.CHROMOSOME_ID,  d.id
	From gene a, gene_map b, map c, cytoband d
	Where a.gene_id = b.gene_id
	And  b.map_id = c.map_id
	And map_location = name));

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
	aRec.id);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

