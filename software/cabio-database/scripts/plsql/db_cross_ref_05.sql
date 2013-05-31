/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure DATABASE_CROSS_REF31_05_LD as

  V_MAXROW NUMBER :=0;

  CURSOR DATABASECROSSCUR IS
	(select distinct rownum, p.PROTEIN_ID ID, r.REFSEQ_PROTEIN_ID
	from NEW_PROTEIN p, AR_SWISSPROT s, AR_REFSEQ_PROTEIN r
	where s.SWISSPROT_ID = p.PRIMARY_ACCESSION  
	and s.PROBE_SET_ID = r.PROBE_SET_ID);

  aID number:=0;

BEGIN

   SELECT MAX(ID) INTO V_MAXROW FROM DATABASE_CROSS_REFERENCE;

   FOR aRec in DATABASECROSSCUR LOOP
      aID := aID + 1;

      INSERT INTO DATABASE_CROSS_REFERENCE(ID, PROTEIN_ID,
      	CROSS_REFERENCE_ID, TYPE, SOURCE_NAME, SOURCE_TYPE)
      	
      VALUES
     	(aRec.ROWNUM + V_MAXROW,aRec.ID,aRec.REFSEQ_PROTEIN_ID,
      	'gov.nih.nci.domain.Protein','REFSEQ_PROTEIN_ID','RefSeq');

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

