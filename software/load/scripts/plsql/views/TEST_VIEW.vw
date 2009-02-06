CREATE OR REPLACE FORCE VIEW CABIODEV.TEST_VIEW
(REPORTER_ID, GENE_ID)
AS 
SELECT reporter_id,
 (SELECT MIN(GENE_ID)
 FROM CLONE_GENE, CLONE
 WHERE CLONE.CLONE_ID = clone_gene.clone_id
 AND CLONE.clone_name = a.reporter_name ) GENE_ID
FROM dcop.reporter@todcop a, dcop.design_element_group@todcop b
WHERE b.design_element_group_id = a.DESIGN_ELEMENT_GROUP_ID
AND array_design_id = 45
AND REPORTER_NAME > ' ';


