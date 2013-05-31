/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure GENE_ALIAS_OBJECT31_TV_LD as

  CURSOR GENEALIASOBJECTTVCUR IS
  (SELECT GENE_ALIAS_ID, ALIAS_TYPE, NAME, GENE_ID from GENE_ALIAS_OBJECT);

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_ALIAS_OBJECT_TV REUSE STORAGE ');

   FOR aRec in GENEALIASOBJECTTVCUR LOOP

      aID := aID + 1;

      INSERT INTO GENE_ALIAS_OBJECT_TV(GENE_ALIAS_ID, ALIAS_TYPE, NAME, GENE_ID)
      VALUES (aRec.GENE_ALIAS_ID,
              aRec.ALIAS_TYPE,
              aRec.NAME,
              aRec.GENE_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

