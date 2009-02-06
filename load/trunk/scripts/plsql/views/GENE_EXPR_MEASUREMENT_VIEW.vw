CREATE OR REPLACE FORCE VIEW CABIODEV.GENE_EXPR_MEASUREMENT_VIEW
(GENE_ID, REPORTER_ID)
AS 
SELECT gs.gene_id, e.reporter_id
FROM SEQUENCE s, GENE_SEQUENCE gs, expression_measurement_view e
WHERE s.accession_number = e.accession
AND s.sequence_id = gs.sequence_id;


