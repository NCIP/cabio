CREATE OR REPLACE procedure DATABASE_CROSS_REF31_04_LD as

  V_MAXROW NUMBER :=0;

  CURSOR DATABASECROSSCUR IS
	(select rownum, g.GENE_ID, e.EC
	from GENE_TV g, ZSTG_RNA_PROBESETS z, AR_EC e 
	where z.UNIGENE_ID = 'Hs.'||g.CLUSTER_ID 
	and z.PROBE_SET_ID = e.PROBE_SET_ID);
	
  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM DATABASE_CROSS_REFERENCE;

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

      INSERT INTO DATABASE_CROSS_REFERENCE(ID, GENE_ID,
      	CROSS_REFERENCE_ID, TYPE, SOURCE_NAME, SOURCE_TYPE)
      	
      VALUES
     	(aRec.rownum + V_MAXROW, aRec.GENE_ID, aRec.EC,
      	'gov.nih.nci.cabio.domain.Gene','EC_ID','Enzyme Commission');

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

