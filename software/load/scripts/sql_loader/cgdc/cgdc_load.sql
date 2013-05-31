/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

ALTER TRIGGER CGDC_ID_INSERT DISABLE;
VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

TRUNCATE TABLE gene_function_association REUSE STORAGE;
@$LOAD/indexes/gene_function_association.drop.sql
COMMIT;
INSERT
  INTO gene_function_association(ID, GENE_ID, evidence_ID, role_ID, 
HISTOLOGYcode_ID, DISCRIMINATOR) SELECT DISTINCT ROWNUM, A.gene_ID, 
A.evidence_ID, A.role_ID, D.histology_code, 'GeneDiseaseOntologyAssociation' AS 
DISCRIMINATOR FROM zstg_gene_disease_evid_cgid A, zstg_diseaseontology_cgid C, 
histology_code D
           WHERE A.disease_ID = C.ID AND C.DISEASEontology = D.HISTOLOGY_NAME; 
COMMIT;
SELECT MAX(ID) + 1 AS V_MAXROW FROM gene_function_association;
INSERT
  INTO gene_function_association(ID, GENE_ID, evidence_ID, role_ID, agent_ID, 
DISCRIMINATOR) SELECT DISTINCT ROWNUM + &V_MAXROW, A.gene_ID, A.evidence_ID, 
A.role_ID, D.agent_ID, 'GeneAgentAssociation' AS DISCRIMINATOR FROM 
zstg_gene_agent_evidence_cgid A, zstg_agent_cgid C, AGENT D
                WHERE A.agent_ID = C.ID AND C.DRUG = D.AGENT_NAME;
COMMIT;
@$LOAD/indexes/gene_function_association.lower.sql
@$LOAD/indexes/gene_function_association.cols.sql
exit;
