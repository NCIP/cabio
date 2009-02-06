CREATE OR REPLACE procedure HOMOLOGOUS_ASSOCIATION31b_LD as

	V_MAXROW NUMBER :=0;

  CURSOR HOMOLASSOCCUR IS
  (SELECT rownum, hs_id, mm_id, sim from
 	(select g2.gene_id hs_id,
                 g.gene_id mm_id,
	             MAX(similarity) sim
	         FROM GENE_TV g,
                  GENE_TV g2,
                  cgap.MM_TO_HS@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity NOT LIKE 'http%'
			 GROUP BY g.gene_id,
                      g2.gene_id));

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM HOMOLOGOUS_ASSOCIATION;

   FOR aRec in HOMOLASSOCCUR LOOP

      aID := aID + 1;

      INSERT INTO HOMOLOGOUS_ASSOCIATION(ID, SIMILARITY_PERCENTAGE, HOMOLOGOUS_ID, HOMOLOGOUS_GENE_ID)
      VALUES (aRec.ROWNUM + V_MAXROW,
              aRec.sim,
              aRec.hs_id,
              aRec.mm_id);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

