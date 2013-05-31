/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure GENE_TV31_LD as

  CURSOR GTVCUR IS
  (SELECT a.GENE_ID GENE_ID,
          a.GENE_TITLE GENE_TITLE,
          a.GENE_SYMBOL GENE_SYMBOL,
          b.IDENTIFIER cluster_ID,
          a.CHROMOSOME_ID CHROMOSOME_ID,
          a.TAXON_ID TAXON_ID
   FROM GENE_stg31 a, Gene_identifiers_stg31 b
	where a.gene_ID = b.gene_ID and b.DATA_SOURCE =1);

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
                          TAXON_ID)
      VALUES
     (aRec.GENE_ID,
      aRec.GENE_TITLE,
      aRec.GENE_SYMBOL,
      aRec.CLUSTER_ID,
      aRec.CHROMOSOME_ID,
      aRec.TAXON_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

