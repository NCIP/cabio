VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

--SELECT MAX(agent_ID) + 1 AS V_MAXROW
  --FROM agent; 

DROP SEQUENCE agent_ID_SEQ;
--CREATE SEQUENCE agent_ID_SEQ START WITH &V_MAXROW INCREMENT BY 1;
CREATE SEQUENCE agent_ID_SEQ;
-- get agent name from zstg_agent_nsc
--UPDATE agent H SET AGENT_NAME = (SELECT AGENT_NAME
                   --                FROM zstg_agents_nsc Z
                   --          WHERE H.NSC_NUMBER = Z.NSC_NUMBER AND ROWNUM = 1);

INSERT
  INTO agent(AGENT_ID, AGENT_NAME, NSC_NUMBER) SELECT AGENT_ID_SEQ.NEXTVAL, 
                                                      D.agent_NAME, D.NSC_NUMBER
                                                 FROM zstg_agents_nsc D
                             WHERE NSC_NUMBER NOT IN (SELECT DISTINCT NSC_NUMBER
                                                                    FROM agent);
COMMIT;
-- get EVS Id from zstg_missing_agent_cgid
-- merge CGDC data into Agent
update agent H set h.evs_id = (select distinct evs_id from zstg_agent_cgid d where trim(lower(h.agent_name)) = trim(lower(d.drug)));
commit;

insert into agent(agent_id,agent_name, evs_id) select agent_id_seq.nextval, agent_name, evs_id from (select distinct lower(trim(drug)) as agent_name, evs_id from zstg_agent_cgid minus select distinct lower(trim(agent_name)), evs_id from agent);
commit;
 
@$LOAD/indexer_new.sql agent
@$LOAD/indexes/agent.drop.sql 
@$LOAD/indexes/agent.cols.sql 
@$LOAD/indexes/agent.lower.sql
  
COMMIT;

--truncate table zstg_agent;
--insert into zstg_agent(agent_id, agent_type, agent_name, agent_source, agent_comment, cmap_agent, nsc_number, evs_id, big_id) select agent_id, agent_type, agent_name, agent_source, agent_comment, cmap_agent, nsc_number, evs_id, big_id from agent;
--commit;
EXIT;
  
