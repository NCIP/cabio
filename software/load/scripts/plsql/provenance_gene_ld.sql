/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure provenance_Gene_LD as

  CURSOR GTVCUR IS
  (SELECT rownum, gene_ID,
'http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi?ORG='
||decode(Taxon_ID, 5, 'Hs', 6, 'Mm')||'&'||'CID='||cluster_ID URL 
FROM gene_TV);

  aID number:=0;
  V_MAXROW NUMBER :=0;

BEGIN

   SELECT MAX(Source_reference_ID) INTO V_MAXROW FROM Source_reference;

Insert into SOURCE (ID, NAME) values (3, 'UNIGENE');

Insert into INTERNET_SOURCE (ID, NAME, OWNER_INSTITUTION, OWNER_PERSONS, SOURCE_URI)
values (3, 'UNIGENE', 'UNIGENE, National Center for Biotechnology Information, National Library Of Medicine',
NULL, 'http://www.ncbi.nlm.nih.gov/');

Commit;

   FOR aRec in GTVCUR LOOP
      aID := aID + 1;

      INSERT INTO Source_reference (
  SOURCE_REFERENCE_ID,
  SOURCE_REFERENCE_TYPE,
  REFERENCE)
      VALUES
     (aRec.rownum + V_MAXROW,
      'URL',
      aRec.URL
      );

	Insert into URL_SOURCE_REFERENCE (
  ID,
  SOURCE_REFERENCE_TYPE,
  SOURCE_URL,
  REFERENCE)
	values (aRec.rownum + V_MAXROW,
	'URL',
	aRec.URL,
	aRec.URL);

      INSERT INTO PROVENANCE (
  ID,
  EVIDENCE_CODE,
  SOURCE_REFERENCE_ID,
  IMMEDIATE_SOURCE_ID,
  SUPPLYING_SOURCE_ID,
  ORIGINAL_SOURCE_ID,
  FULLY_QUALIFIED_CLASS_NAME,
  OBJECT_IDENTIFIER)
      VALUES
     (aRec.rownum + V_MAXROW,
      'EV-AS-TAS',
      aRec.rownum + V_MAXROW,
      3,
      2,
      3,
	'gov.nih.nci.cabio_fut.domain.gene',
	aRec.gene_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

