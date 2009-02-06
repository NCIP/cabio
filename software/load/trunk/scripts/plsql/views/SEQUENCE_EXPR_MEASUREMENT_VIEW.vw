CREATE OR REPLACE FORCE VIEW CABIODEV.SEQUENCE_EXPR_MEASUREMENT_VIEW
(SEQUENCE_ID, REPORTER_ID)
AS 
SELECT s.sequence_id, e.reporter_id
FROM SEQUENCE s, expression_measurement_view e
WHERE s.accession_number = e.accession;


