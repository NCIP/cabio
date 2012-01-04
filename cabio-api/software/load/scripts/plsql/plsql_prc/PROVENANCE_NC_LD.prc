CREATE OR REPLACE procedure provenance_NC_LD as

  CURSOR GTVCUR IS
  (SELECT rownum, ID,
'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=nucleotide'
||'&'||'cmd=search'||'&'||'term='||accession_number URL FROM 
NUCLEIC_ACID_SEQUENCE);

  aID number:=0;
  V_MAXROW NUMBER :=0;

BEGIN

   SELECT MAX(Source_reference_ID) INTO V_MAXROW FROM Source_reference;

Insert into SOURCE (ID, NAME) values (4, 'Nucleotide');

Insert into INTERNET_SOURCE (ID, NAME, OWNER_INSTITUTION, OWNER_PERSONS, SOURCE_URI)
values (4, 'Nucleotide', 'Nucleotide, National Center for Biotechnology Information, National Library Of Medicine',
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
      4,
      2,
      4,
	'gov.nih.nci.cabio.domain.nucleicacidsequence',
	aRec.ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

