/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

ALTER TRIGGER CGDC_ID_INSERT DISABLE;
ALTER TRIGGER test_trig DISABLE;

drop sequence CGDC_ID;
create sequence CGDC_ID;
TRUNCATE TABLE gene_function_association REUSE STORAGE;
@$LOAD/indexes/gene_function_association.drop.sql
COMMIT;
INSERT
  INTO gene_function_association(ID, GENE_ID, evidence_ID, role_ID, 
HISTOLOGYcode_ID, DISCRIMINATOR) SELECT CGDC_ID.nextval, A.gene_ID, 
A.evidence_ID, A.role_ID, D.histology_code, 'GeneDiseaseOntologyAssociation' AS 
DISCRIMINATOR FROM zstg_gene_disease_evid_cgid A, zstg_diseaseontology_cgid C, 
histology_code D
           WHERE A.disease_ID = C.ID AND lower(trim(C.DISEASEontology)) = lower(trim(D.HISTOLOGY_NAME)) and c.evs_id=d.evs_id; 
COMMIT;
INSERT
  INTO gene_function_association(ID, GENE_ID, evidence_ID, role_ID, agent_ID, 
DISCRIMINATOR) SELECT CGDC_ID.nextval, A.gene_ID, A.evidence_ID, 
A.role_ID, D.agent_ID, 'GeneAgentAssociation' AS DISCRIMINATOR FROM 
zstg_gene_agent_evidence_cgid A, zstg_agent_cgid C, AGENT D
                WHERE A.agent_ID = C.ID AND lower(trim(C.DRUG)) = lower(trim(D.AGENT_NAME)) and c.evs_id=d.evs_id;
COMMIT;
@$LOAD/indexes/gene_function_association.lower.sql
@$LOAD/indexes/gene_function_association.cols.sql
exit;
