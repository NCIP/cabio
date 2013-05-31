/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure CHROMOSOME_LD as

  V_MAXROW NUMBER :=0;

  CURSOR CHROMOSOMECUR IS
  	(select rownum, tname from (
	select unique tname from ALL_MRNA_MOUSE_STG01
	minus
	select CHROMOSOME_NUMBER from CHROMOSOME)
	);

  aID number:=0;

BEGIN

   SELECT MAX(chromosome_ID) INTO V_MAXROW from chromosome;

   FOR aRec in CHROMOSOMECUR LOOP
      aID := aID + 1;

      INSERT INTO CHROMOSOME(CHROMOSOME_ID,
                          TAXON_ID,
                          CHROMOSOME_NUMBER)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      6,
      aRec.TNAME);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

