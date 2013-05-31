/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure HOMOLOGOUS_ASSOCIATION31a_LD as

  CURSOR HOMOLASSOCCUR IS
  (SELECT ROWNUM, hs_id, mm_id, sim
	from (select g.gene_id hs_id,
                 g2.gene_id mm_id,
	             MAX(similarity) sim
	         FROM GENE_TV g,
                  GENE_TV g2,
                  cgap.HS_TO_MM@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity NOT LIKE 'http%'
			  GROUP BY g.gene_id,
                       g2.gene_id));

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE HOMOLOGOUS_ASSOCIATION REUSE STORAGE ');

   FOR aRec in HOMOLASSOCCUR LOOP

      aID := aID + 1;

      INSERT INTO HOMOLOGOUS_ASSOCIATION(ID, SIMILARITY_PERCENTAGE, HOMOLOGOUS_ID, HOMOLOGOUS_GENE_ID)
      VALUES (aRec.ROWNUM,
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

