CREATE OR REPLACE FORCE VIEW CABIODEV.SEQUENCE_DB_REF_VIEW
(SEQUENCE_ID, DATABASE_REFERENCE_ID)
AS 
SELECT SEQUENCE_ID, DATABASE_REFERENCE_ID
FROM SEQUENCE S, DCop.DATABASE_REFERENCE@todcop D
WHERE DECODE(INSTR(ACCESSION, '.'), 0, accession,
 SUBSTR(accession, 0, INSTR(ACCESSION, '.')-1)) = ACCESSION_NUMBER;

