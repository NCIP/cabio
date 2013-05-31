/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/zstg_agent_cgid.cols.sql;
@$LOAD/indexes/zstg_rolecode_cgid.cols.sql;
@$LOAD/indexes/zstg_agents_nsc.cols.sql;
@$LOAD/indexes/zstg_diseaseontology_cgid.cols.sql;
@$LOAD/indexes/evidence_code.cols.sql;
@$LOAD/indexes/evidence.cols.sql;
@$LOAD/indexes/evidence_evidence_code.cols.sql;
@$LOAD/indexes/zstg_gene_evidence_cgid.cols.sql;
@$LOAD/indexes/zstg_gene_diseaseonto_cgid.cols.sql;
@$LOAD/indexes/zstg_gene_agent_cgid.cols.sql;
@$LOAD/indexes/zstg_gene_role_cgid.cols.sql;
@$LOAD/indexes/zstg_gene_genealias_cgid.cols.sql;
@$LOAD/indexes/zstg_missing_agent_cgid.cols.sql;
@$LOAD/indexes/zstg_missing_diseaseontol_cgid.cols.sql;
@$LOAD/indexes/zstg_rolecode_cgid.cols.sql;
@$LOAD/indexes/zstg_gene_agent_evidence_cgid.cols.sql
@$LOAD/indexes/zstg_gene_disease_evid_cgid.cols.sql

@$LOAD/indexes/zstg_agent_cgid.lower.sql;
@$LOAD/indexes/zstg_rolecode_cgid.lower.sql;
@$LOAD/indexes/zstg_agents_nsc.lower.sql;
@$LOAD/indexes/zstg_diseaseontology_cgid.lower.sql;
@$LOAD/indexes/evidence_code.lower.sql;
@$LOAD/indexes/evidence.lower.sql;
@$LOAD/indexes/evidence_evidence_code.lower.sql;
@$LOAD/indexes/zstg_gene_evidence_cgid.lower.sql;
@$LOAD/indexes/zstg_gene_diseaseonto_cgid.lower.sql;
@$LOAD/indexes/zstg_gene_agent_cgid.lower.sql;
@$LOAD/indexes/zstg_gene_role_cgid.lower.sql;
@$LOAD/indexes/zstg_gene_genealias_cgid.lower.sql;
@$LOAD/indexes/zstg_missing_agent_cgid.lower.sql;
@$LOAD/indexes/zstg_missing_diseaseontol_cgid.lower.sql;
@$LOAD/indexes/zstg_rolecode_cgid.lower.sql;
@$LOAD/indexes/zstg_gene_agent_evidence_cgid.lower.sql
@$LOAD/indexes/zstg_gene_disease_evid_cgid.lower.sql

@$LOAD/constraints/zstg_agent_cgid.enable.sql;
@$LOAD/constraints/zstg_rolecode_cgid.enable.sql;
@$LOAD/constraints/zstg_agents_nsc.enable.sql;
@$LOAD/constraints/zstg_diseaseontology_cgid.enable.sql;
@$LOAD/constraints/evidence_code.enable.sql;
@$LOAD/constraints/evidence.enable.sql;
@$LOAD/constraints/evidence_evidence_code.enable.sql;
@$LOAD/constraints/zstg_gene_evidence_cgid.enable.sql;
@$LOAD/constraints/zstg_gene_diseaseonto_cgid.enable.sql;
@$LOAD/constraints/zstg_gene_agent_cgid.enable.sql;
@$LOAD/constraints/zstg_gene_role_cgid.enable.sql;
@$LOAD/constraints/zstg_gene_genealias_cgid.enable.sql;
@$LOAD/constraints/zstg_missing_agent_cgid.enable.sql;
@$LOAD/constraints/zstg_missing_diseaseontol_cgid.enable.sql;
@$LOAD/constraints/zstg_rolecode_cgid.enable.sql;
@$LOAD/constraints/gene_function_association.enable.sql;


@$LOAD/triggers/zstg_agent_cgid.enable.sql;
@$LOAD/triggers/zstg_rolecode_cgid.enable.sql;
@$LOAD/triggers/zstg_agents_nsc.enable.sql;
@$LOAD/triggers/zstg_diseaseontology_cgid.enable.sql;
@$LOAD/triggers/evidence_code.enable.sql;
@$LOAD/triggers/evidence.enable.sql;
@$LOAD/triggers/evidence_evidence_code.enable.sql;
@$LOAD/triggers/zstg_gene_evidence_cgid.enable.sql;
@$LOAD/triggers/zstg_gene_diseaseonto_cgid.enable.sql;
@$LOAD/triggers/zstg_gene_agent_cgid.enable.sql;
@$LOAD/triggers/zstg_gene_role_cgid.enable.sql;
@$LOAD/triggers/zstg_gene_genealias_cgid.enable.sql;
@$LOAD/triggers/zstg_missing_agent_cgid.enable.sql;
@$LOAD/triggers/zstg_missing_diseaseontol_cgid.enable.sql;
@$LOAD/triggers/zstg_rolecode_cgid.enable.sql;
@$LOAD/triggers/gene_function_association.enable.sql;

--INSERT
--  INTO agent_diseaseontology (AGENT_ID, DISEASEontology_ID) SELECT DISTINCT 
--                                                        B.agent_ID, C.disease_ID
--                       FROM zstg_gene_agent_cgid B, zstg_gene_diseaseONTO_CGID C
--                                                   WHERE B.gene_ID = C.GENE_ID;

--COMMIT;

UPDATE evidence SET SENTENCE_SUBSTR = SUBSTR(SENTENCE, 0, 100);
COMMIT;

ANALYZE TABLE zstg_gene_role_cgid COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene_agent_cgid COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene_diseaseonto_cgid COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene_evidence_cgid COMPUTE STATISTICS;

ANALYZE TABLE evidence COMPUTE STATISTICS;
ANALYZE TABLE evidence_code COMPUTE STATISTICS;
ANALYZE TABLE zstg_agent_cgid COMPUTE STATISTICS;
--ANALYZE TABLE zstg_diseaseontology_cgid COMPUTE STATISTICS;
ANALYZE TABLE agent_diseaseontology COMPUTE STATISTICS;
ANALYZE TABLE evidence_evidence_code COMPUTE STATISTICS;

EXIT;
