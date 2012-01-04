CREATE OR REPLACE FORCE VIEW CABIODEV.PATHWAY_CONTEXT
(PATHWAY_ID, TISSUE_NAME)
AS 
SELECT DISTINCT
gp.pathway_id, tissue_name
FROM GENE_PATHWAY gp, BIOGENES b, GENE_TARGET gt, ANOMALY a, CONTEXT c, TISSUE_CODE t, TISSUE_CLOSURE tc
WHERE b.gene_id = gt.gene_id
  AND gp.bc_id = b.bc_id
  AND gt.target_id = a.target_id
  AND c.context_code = a.context_code
  AND C.TISSUE_CODE = t.TISSUE_CODE
  AND ancestor = t.TISSUE_CODE;


