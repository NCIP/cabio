/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure DATABASE_CROSS_REF31_01_LD as

  CURSOR DATABASECROSSCUR IS
   (select rownum, gene_id, identifier
    FROM GENE_IDENTIFIERS_STG31 where DATA_SOURCE = 2
   );

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE DATABASE_CROSS_REFERENCE REUSE STORAGE');

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

      INSERT INTO DATABASE_CROSS_REFERENCE(ID, GENE_ID,
      	CROSS_REFERENCE_ID, TYPE, SOURCE_NAME, SOURCE_TYPE)
      VALUES
        (aRec.ROWNUM, aRec.GENE_ID, aRec.identifier,
      	'gov.nih.nci.domain.Gene','LOCUS_LINK_ID','UNIGENE');
		
      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

