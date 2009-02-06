CREATE OR REPLACE procedure GENE_TV_LD as

  CURSOR GTVCUR IS
  (SELECT GENE_ID,
          GENE_TITLE,
          GENE_SYMBOL,
          CLUSTER_ID,
          CHROMOSOME_ID,
          TAXON_ID,
          ENGINEEREDGENE_ID
   FROM GENE);

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_TV REUSE STORAGE ');

   FOR aRec in GTVCUR LOOP
      aID := aID + 1;

      INSERT INTO GENE_TV(GENE_ID,
                          FULL_NAME,
                          SYMBOL,
                          CLUSTER_ID,
                          CHROMOSOME_ID,
                          TAXON_ID,
                          ENGINEEREDGENE_ID)
      VALUES
     (aRec.GENE_ID,
      aRec.GENE_TITLE,
      aRec.GENE_SYMBOL,
      aRec.CLUSTER_ID,
      aRec.CHROMOSOME_ID,
      aRec.TAXON_ID,
      aRec.ENGINEEREDGENE_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

