
TRUNCATE TABLE zstg_agent_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_rolecode_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_agents_nsc REUSE STORAGE;
TRUNCATE TABLE zstg_diseaseontology_cgid REUSE STORAGE; 
TRUNCATE TABLE evidence_code REUSE STORAGE;
TRUNCATE TABLE evidence REUSE STORAGE;
TRUNCATE TABLE evidence_evidence_code REUSE STORAGE;
TRUNCATE TABLE zstg_gene_agent_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_diseaseonto_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_evidence_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_genealias_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_role_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_rolecode_cgid REUSE STORAGE;
#TRUNCATE TABLE gene_function_association REUSE STORAGE;
TRUNCATE TABLE zstg_missing_agent_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_missing_diseaseontol_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_disease_evid_cgid REUSE STORAGE;
TRUNCATE TABLE zstg_gene_agent_evidence_cgid REUSE STORAGE;
TRUNCATE TABLE agent REUSE STORAGE;

@$LOAD/indexer_new.sql zstg_agent_cgid
@$LOAD/indexer_new.sql zstg_rolecode_cgid
@$LOAD/indexer_new.sql zstg_agents_nsc
@$LOAD/indexer_new.sql zstg_diseaseontology_cgid
@$LOAD/indexer_new.sql evidence_code
@$LOAD/indexer_new.sql evidence
@$LOAD/indexer_new.sql evidence_evidence_code
@$LOAD/indexer_new.sql zstg_gene_agent_cgid
@$LOAD/indexer_new.sql zstg_gene_diseaseonto_cgid 
@$LOAD/indexer_new.sql zstg_gene_evidence_cgid 
@$LOAD/indexer_new.sql zstg_gene_genealias_cgid 
@$LOAD/indexer_new.sql zstg_gene_role_cgid 
@$LOAD/indexer_new.sql zstg_rolecode_cgid 
@$LOAD/indexer_new.sql gene_function_association 
@$LOAD/indexer_new.sql zstg_missing_agent_cgid 
@$LOAD/indexer_new.sql zstg_missing_diseaseontol_cgid 
@$LOAD/indexer_new.sql zstg_gene_agent_evidence_cgid 
@$LOAD/indexer_new.sql zstg_gene_disease_evid_cgid 

@$LOAD/constraints.sql zstg_agent_cgid
@$LOAD/constraints.sql zstg_rolecode_cgid
@$LOAD/constraints.sql zstg_agents_nsc
@$LOAD/constraints.sql zstg_diseaseontology_cgid
@$LOAD/constraints.sql evidence_code
@$LOAD/constraints.sql evidence
@$LOAD/constraints.sql evidence_evidence_code
@$LOAD/constraints.sql zstg_gene_agent_cgid
@$LOAD/constraints.sql zstg_gene_genealias_cgid
@$LOAD/constraints.sql zstg_gene_diseaseonto_cgid 
@$LOAD/constraints.sql zstg_gene_evidence_cgid 
@$LOAD/constraints.sql zstg_gene_role_cgid 
@$LOAD/constraints.sql zstg_rolecode_cgid 
@$LOAD/constraints.sql gene_function_association 
@$LOAD/constraints.sql zstg_missing_agent_cgid 
@$LOAD/constraints.sql zstg_gene_agent_evidence_cgid 
@$LOAD/constraints.sql zstg_gene_disease_evid_cgid 
@$LOAD/constraints.sql zstg_missing_diseaseontol_cgid 

@$LOAD/triggers.sql zstg_agent_cgid
@$LOAD/triggers.sql zstg_rolecode_cgid
@$LOAD/triggers.sql zstg_agents_nsc
@$LOAD/triggers.sql zstg_diseaseontology_cgid
@$LOAD/triggers.sql evidence_code
@$LOAD/triggers.sql evidence
@$LOAD/triggers.sql evidence_evidence_code
@$LOAD/triggers.sql zstg_gene_agent_cgid
@$LOAD/triggers.sql zstg_gene_genealias_cgid
@$LOAD/triggers.sql zstg_gene_diseaseonto_cgid 
@$LOAD/triggers.sql zstg_gene_evidence_cgid 
@$LOAD/triggers.sql zstg_gene_role_cgid 
@$LOAD/triggers.sql zstg_rolecode_cgid 
@$LOAD/triggers.sql gene_function_association 
@$LOAD/triggers.sql zstg_missing_agent_cgid 
@$LOAD/triggers.sql zstg_missing_diseaseontol_cgid 

@$LOAD/constraints/zstg_agent_cgid.disable.sql
@$LOAD/constraints/zstg_rolecode_cgid.disable.sql
@$LOAD/constraints/zstg_agents_nsc.disable.sql
@$LOAD/constraints/zstg_diseaseontology_cgid.disable.sql
@$LOAD/constraints/evidence_code.disable.sql
@$LOAD/constraints/evidence.disable.sql
@$LOAD/constraints/evidence_evidence_code.disable.sql
@$LOAD/constraints/zstg_gene_agent_cgid.disable.sql
@$LOAD/constraints/zstg_gene_genealias_cgid.disable.sql
@$LOAD/constraints/zstg_gene_diseaseonto_cgid.disable.sql
@$LOAD/constraints/zstg_gene_evidence_cgid.disable.sql
@$LOAD/constraints/zstg_gene_role_cgid.disable.sql
@$LOAD/constraints/zstg_rolecode_cgid.disable.sql
@$LOAD/constraints/gene_function_association.disable.sql
@$LOAD/constraints/zstg_missing_agent_cgid.disable.sql
@$LOAD/constraints/zstg_missing_diseaseontol_cgid.disable.sql

@$LOAD/indexes/zstg_agent_cgid.drop.sql
@$LOAD/indexes/zstg_agents_nsc.drop.sql
@$LOAD/indexes/zstg_rolecode_cgid.drop.sql
@$LOAD/indexes/zstg_gene_role_cgid.drop.sql
@$LOAD/indexes/zstg_diseaseontology_cgid.drop.sql
@$LOAD/indexes/evidence_code.drop.sql
@$LOAD/indexes/evidence.drop.sql
@$LOAD/indexes/evidence_evidence_code.drop.sql
@$LOAD/indexes/zstg_gene_agent_cgid.drop.sql
@$LOAD/indexes/zstg_gene_genealias_cgid.drop.sql
@$LOAD/indexes/zstg_gene_diseaseonto_cgid.drop.sql
@$LOAD/indexes/zstg_gene_evidence_cgid.drop.sql
@$LOAD/indexes/zstg_gene_role_cgid.drop.sql
@$LOAD/indexes/zstg_rolecode_cgid.drop.sql
#@$LOAD/indexes/gene_function_association.drop.sql
@$LOAD/indexes/zstg_missing_agent_cgid.drop.sql
@$LOAD/indexes/zstg_gene_agent_evidence_cgid.drop.sql
@$LOAD/indexes/zstg_gene_disease_evid_cgid.drop.sql
@$LOAD/indexes/zstg_missing_diseaseontol_cgid.drop.sql

@$LOAD/triggers/zstg_agent_cgid.disable.sql
@$LOAD/triggers/zstg_rolecode_cgid.disable.sql
@$LOAD/triggers/zstg_agents_nsc.disable.sql
@$LOAD/triggers/zstg_diseaseontology_cgid.disable.sql
@$LOAD/triggers/evidence_code.disable.sql
@$LOAD/triggers/evidence.disable.sql
@$LOAD/triggers/evidence_evidence_code.disable.sql
@$LOAD/triggers/zstg_gene_agent_cgid.disable.sql
@$LOAD/triggers/zstg_gene_genealias_cgid.disable.sql
@$LOAD/triggers/zstg_gene_diseaseonto_cgid.disable.sql
@$LOAD/triggers/zstg_gene_evidence_cgid.disable.sql
@$LOAD/triggers/zstg_gene_role_cgid.disable.sql
@$LOAD/triggers/zstg_rolecode_cgid.disable.sql
#@$LOAD/triggers/gene_function_association.disable.sql
@$LOAD/triggers/zstg_missing_agent_cgid.disable.sql
@$LOAD/triggers/zstg_missing_diseaseontol_cgid.disable.sql

COMMIT;
EXIT
