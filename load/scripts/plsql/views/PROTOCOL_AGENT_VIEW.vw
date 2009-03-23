CREATE OR REPLACE FORCE VIEW CABIODEV.PROTOCOL_AGENT_VIEW
(PRO_ID, AGENT_ID, AGENT_TYPE, AGENT_NAME, AGENT_SOURCE, 
 AGENT_COMMENT, CMAP_AGENT, NSC_NUMBER, EVS_ID)
AS 
SELECT PRO_ID, AGENT.* FROM
PROTOCOL_AGENTS, AGENT
WHERE PROTOCOL_AGENTS.AGENT_ID = AGENT.AGENT_ID;

