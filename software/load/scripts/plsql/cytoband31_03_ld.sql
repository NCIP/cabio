/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure CYTOBAND31_03_LD as

  V_MAXROW NUMBER :=0;

 CURSOR PHYCUR IS
  (SELECT ROWNUM, CYTOBAND FROM (
	SELECT CYTOBAND FROM CLONE_DIM
	MINUS
	SELECT NAME CYTOBAND FROM CYTOBAND));

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM CYTOBAND;

   FOR aRec in PHYCUR LOOP
      aID := aID + 1;

      INSERT INTO CYTOBAND (ID,
                          NAME)
      VALUES
     (aRec.ROWNUM + V_MAXROW,
      aRec.CYTOBAND);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

