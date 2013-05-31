/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--TRUNCATE TABLE zstg_cmap_genes REUSE STORAGE;
--TRUNCATE TABLE zstg_cmap_agents REUSE STORAGE;
--TRUNCATE TABLE zstg_cmap_targets REUSE STORAGE;
--TRUNCATE TABLE zstg_cmap_targetagents REUSE STORAGE;
--TRUNCATE TABLE zstg_cmap_ids REUSE STORAGE;
--TRUNCATE TABLE zstg_cmap_names REUSE STORAGE;
--TRUNCATE TABLE ontology_relationship REUSE STORAGE;

TRUNCATE TABLE agent REUSE STORAGE;
TRUNCATE TABLE target REUSE STORAGE;
TRUNCATE TABLE gene_target REUSE STORAGE;
TRUNCATE TABLE target_agent REUSE STORAGE;
VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;


@$LOAD/indexer_new.sql target
@$LOAD/indexer_new.sql gene_target
@$LOAD/indexer_new.sql target_agent
@$LOAD/indexer_new.sql anomaly

@$LOAD/constraints.sql target
@$LOAD/constraints.sql gene_target
@$LOAD/constraints.sql target_agent

@$LOAD/triggers.sql target
@$LOAD/triggers.sql gene_target
@$LOAD/triggers.sql target_agent

@$LOAD/indexes/target.drop.sql
@$LOAD/indexes/gene_target.drop.sql
@$LOAD/indexes/target_agent.drop.sql
@$LOAD/indexes/anomaly.drop.sql

@$LOAD/constraints/target.disable.sql
@$LOAD/constraints/gene_target.disable.sql
@$LOAD/constraints/target_agent.disable.sql

@$LOAD/triggers/target.disable.sql
@$LOAD/triggers/gene_target.disable.sql
@$LOAD/triggers/target_agent.disable.sql

insert into agent(agent_id, agent_type, agent_name, agent_source, agent_comment, cmap_agent, nsc_number, evs_id, big_id) select agent_id, agent_type, agent_name, agent_source, agent_comment, cmap_agent, nsc_number, evs_id, big_id from zstg_agent;

commit; 

drop sequence target_id;
create sequence target_id;
alter trigger set_target_id enable;
--INSERT INTO zstg_cmap_genes(gene_id,gene_name) SELECT distinct c.gene_id,gene_name FROM CMAP.CMAP_GENES@WEB.NCI.NIH.GOV a,zstg_gene2unigene b, gene_tv c WHERE b.geneid = a.gene_id and decode(substr(b.unigene_cluster,0,2),'Hs',5,'Mm',6)=c.taxon_id;

--INSERT INTO zstg_cmap_agents(agent_id,agent_name,agent_source,agent_comment) SELECT distinct SUBSTR(agent_id, 3),agent_name,agent_source,agent_comment FROM CMAP.CMAP_agentS@WEB.NCI.NIH.GOV;

SELECT MAX(agent_ID)+1 AS V_MAXROW FROM AGENT; 
DROP SEQUENCE agent_ID_SEQ;
CREATE SEQUENCE agent_id_seq start with &V_MAXROW increment by 1;


insert into agent(agent_id, agent_name, agent_source, agent_comment) select agent_id_seq.nextval, agent_name, agent_source, agent_comment from (select distinct lower(trim(agent_name)) as agent_name, lower(trim(d.agent_source)) as agent_source, lower(trim(d.agent_comment)) as agent_comment from zstg_cmap_agents d minus select distinct lower(trim(agent_name)) as agent_name, lower(trim(agent_source)) as agent_source, lower(trim(agent_comment)) as agent_comment from agent);
commit;

--INSERT INTO zstg_cmap_targets(target_id,gene_id, anomaly,cancer_type) SELECT distinct SUBSTR(target_id, 3), zstg_gene_identifiers.gene_id,ANOMALY,cancer_type FROM CMAP.CMAP_targetS@WEB.NCI.NIH.GOV CMAP_T,zstg_gene_identifiers WHERE data_source = 2 AND zstg_gene_IDENTIFIERS.identifier = CMAP_T.gene_id; 

--INSERT INTO zstg_cmap_targetagents(target_id, agent_id) SELECT distinct SUBSTR(target_id, 3), SUBSTR(agent_id, 3) FROM CMAP.CMAP_targetagentS@WEB.NCI.NIH.GOV CMAP_T;

--INSERT INTO zstg_cmap_names(cmap_id, cmap_name) SELECT DISTINCT cmap_id, cmap_name FROM CMAP.CMAP_NAMES@WEB.NCI.NIH.GOV CMAP_T;

--INSERT INTO zstg_cmap_ids(cmap_id, gene_id) SELECT cmap_id,zstg_gene_identifiers.gene_id FROM CMAP.CMAP_IDS@WEB.NCI.NIH.GOV CMAP_I,zstg_gene_identifiers WHERE data_source = 2 AND zstg_gene_IDENTIFIERS.identifier = CMAP_I.locus_id;

--INSERT INTO ontology_relationship(parent_id, child_id, relationship) SELECT DISTINCT cmap_parent, cmap_id, 'part-OF' rel FROM CMAP.CMAP_NAMES@WEB.NCI.NIH.GOV;
COMMIT; 

INSERT INTO target(TARGET_NAME, LOCUS_ID, TARGET_TYPE) select distinct X.target_name, X.locus_id, X.target_type from ( select distinct target_id, g.gene_id, symbol TARGET_NAME, gi.identifier LOCUS_ID, cancer_type, anomaly, 'gene' as TARGET_TYPE FROM gene_tv g, zstg_cmap_targets z, zstg_gene_identifiers gi WHERE g.gene_id = z.gene_id and g.gene_id = gi.gene_id and gi.data_source = 2) X; 

INSERT INTO gene_target(target_id, gene_id) select distinct t.target_id, g.gene_id FROM TARGET t, zstg_gene2unigene x, gene_tv g WHERE t.locus_id = x.GENEID and decode(substr(x.UNIGENE_CLUSTER,0,2),'Hs',5,'Mm',6) = g.taxon_id and substr(x.unigene_cluster,instr(x.unigene_cluster,'.')+1) = g.CLUSTER_ID; 

INSERT INTO target_agent(target_id, agent_id) SELECT t.target_id, a.agent_id FROM zstg_cmap_targetagents z, TARGET t, AGENT a, zstg_cmap_agents za WHERE t.target_id = z.target_id and z.agent_id = za.agent_id and trim(lower(za.agent_name)) = trim(lower(a.agent_name)) and trim(lower(a.agent_source)) = trim(lower(za.agent_source)) and trim(lower(za.agent_comment)) = trim(lower(a.agent_comment));

alter trigger set_target_id disable;
@$LOAD/indexes/target.cols.sql
@$LOAD/indexes/gene_target.cols.sql
@$LOAD/indexes/target_agent.cols.sql
@$LOAD/indexes/anomaly.cols.sql

@$LOAD/indexes/target.lower.sql
@$LOAD/indexes/gene_target.lower.sql
@$LOAD/indexes/target_agent.lower.sql
@$LOAD/indexes/anomaly.lower.sql

@$LOAD/constraints/target.enable.sql
@$LOAD/constraints/gene_target.enable.sql
@$LOAD/constraints/target_agent.enable.sql

@$LOAD/triggers/target.enable.sql
@$LOAD/triggers/gene_target.enable.sql
@$LOAD/triggers/target_agent.enable.sql

EXIT;
