--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql gene_function_association;
@$LOAD/indexer_new.sql gene_function_assoc_evidence;
@$LOAD/indexer_new.sql evidence;
@$LOAD/indexer_new.sql agent;
@$LOAD/indexer_new.sql agent_agent_alias;
@$LOAD/indexer_new.sql agent_alias;

-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql gene_function_association;
@$LOAD/constraints.sql gene_function_assoc_evidence;
@$LOAD/constraints.sql evidence;
@$LOAD/constraints.sql agent;
@$LOAD/constraints.sql agent_agent_alias;
@$LOAD/constraints.sql agent_alias;

-- Disable constraints 
@$LOAD/constraints/gene_function_association.disable.sql;
@$LOAD/constraints/gene_function_assoc_evidence.disable.sql;
@$LOAD/constraints/evidence.disable.sql;
@$LOAD/constraints/agent.disable.sql;
@$LOAD/constraints/agent_agent_alias.disable.sql;
@$LOAD/constraints/agent_alias.disable.sql;

-- Truncate target tables
truncate table gene_function_assoc_evidence;
truncate table agent_agent_alias;
truncate table agent_alias;

--Drop indexes for relevant tables 
@$LOAD/indexes/gene_function_association.drop.sql;
@$LOAD/indexes/gene_function_assoc_evidence.drop.sql;
@$LOAD/indexes/evidence.drop.sql;
@$LOAD/indexes/agent.drop.sql;
@$LOAD/indexes/agent_agent_alias.drop.sql;
@$LOAD/indexes/agent_alias.drop.sql;

EXIT;
