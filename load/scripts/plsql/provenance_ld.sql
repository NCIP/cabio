CREATE OR REPLACE procedure provenance_LD as

  CURSOR GTVCUR IS
  (SELECT rownum, protein_ID,
'http://www.pir.uniprot.org/cgi-bin/upEntry?id='||rtrim(primary_accession) URL FROM new_protein);

  aID number:=0;

BEGIN

   EXECUTE IMMEDIATE('TRUNCATE TABLE provenance REUSE STORAGE');
   EXECUTE IMMEDIATE('TRUNCATE TABLE URL_source_reference REUSE STORAGE');
   EXECUTE IMMEDIATE('TRUNCATE TABLE source REUSE STORAGE');
   EXECUTE IMMEDIATE('TRUNCATE TABLE internet_source REUSE STORAGE');
   EXECUTE IMMEDIATE('TRUNCATE TABLE source_reference REUSE STORAGE');

Insert into SOURCE (ID, NAME) values (1, 'PIR');
Insert into SOURCE (ID, NAME) values (2, 'caBIO');

Insert into INTERNET_SOURCE (ID, NAME, OWNER_INSTITUTION, OWNER_PERSONS, SOURCE_URI)
values (1, 'PIR', 'Protein Information Resource, National Biomedical Research Foundation, Georgetown University',
'Dr. Cathy H. Wu', 'http://pir.georgetown.edu');

Insert into INTERNET_SOURCE (ID, NAME, OWNER_INSTITUTION, OWNER_PERSONS, SOURCE_URI)
values (2, 'caBIO', 'NCI Center for Bioinformatics', 'Dr. George A. Komatsoulis',
'http://cabio_fut.nci.nih.nih.gov/cacore30/server/HTTPServer');

Commit;

   FOR aRec in GTVCUR LOOP
      aID := aID + 1;

      INSERT INTO Source_reference (
  SOURCE_REFERENCE_ID,
  SOURCE_REFERENCE_TYPE,
  REFERENCE)
      VALUES
     (aRec.protein_ID,
      'URL',
      aRec.URL
      );

	Insert into URL_SOURCE_REFERENCE (
  ID,
  SOURCE_REFERENCE_TYPE,
  SOURCE_URL,
  REFERENCE)
	values (aRec.protein_ID,
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
     (aRec.rownum,
      'EV-AS-TAS',
      aRec.protein_ID,
      1,
      2,
      1,
	'gov.nih.nci.cabio_fut.domain.Protein',
	aRec.protein_ID);

      IF MOD(aID, 500) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;

COMMIT;

END; 
/

