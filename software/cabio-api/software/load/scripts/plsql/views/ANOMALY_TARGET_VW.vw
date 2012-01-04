CREATE OR REPLACE FORCE VIEW CABIODEV.ANOMALY_TARGET_VW
(TARGET_ID, ANOMALY_ID, ANOMALY_TYPE, LIBRARY_ID)
AS 
SELECT
  a.target_id,
  a.anomaly_id,
  a.anomaly_type,
  ae.library_id
FROM
  CONTEXT c1,
  CONTEXT c2,
  HISTOLOGY_CLOSURE hc,
  TISSUE_CLOSURE tc,
  ANOMALY a,
  ANOMALY_EXPRESSION ae
WHERE c1.TISSUE_CODE = tc.TISSUE_CODE
  AND c2.TISSUE_CODE = tc.ancestor
  AND c1.HISTOLOGY_CODE = hc.HISTOLOGY_CODE
  AND c2.HISTOLOGY_CODE = hc.ancestor
  AND c1.context_code = a.context_code
  AND c2.context_code = -1
  AND a.anomaly_id = ae.anomaly_id (+);


