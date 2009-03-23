CREATE OR REPLACE procedure DATABASE_CROSS_REF31_02_LD as

  V_MAXROW NUMBER :=0;

  CURSOR DATABASECROSSCUR IS
   (select rownum, c.gene_ID gene_ID, b.omim_number omim_ID 
  	from zstg_gene2unigene a, zstg_omim2gene b, gene_TV c
	where a.geneID = b.geneID 
	and substr(a.unigene_cluster, instr(a.unigene_cluster, '.') + 1) = c.cluster_ID
	and c.taxon_ID = 5);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM DATABASE_CROSS_REFERENCE;

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

      INSERT INTO DATABASE_CROSS_REFERENCE(ID, GENE_ID,
      	CROSS_REFERENCE_ID, TYPE, SOURCE_NAME, SOURCE_TYPE)
      	
      VALUES
     	(aRec.ROWNUM + V_MAXROW, aRec.GENE_ID,aRec.OMIM_ID,
      	'gov.nih.nci.cabio_fut.domain.Gene','OMIM_ID','UNIGENE');

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

