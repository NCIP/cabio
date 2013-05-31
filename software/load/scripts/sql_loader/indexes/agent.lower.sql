/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AGENTGENT_EVS_ID_lwr on AGENT(lower(EVS_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index AGENTGENT_AGENT_COMM_lwr on AGENT(lower(AGENT_COMMENT)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index AGENTGENT_AGENT_SOUR_lwr on AGENT(lower(AGENT_SOURCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index AGENTGENT_AGENT_NAME_lwr on AGENT(lower(AGENT_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index AGENTGENT_AGENT_TYPE_lwr on AGENT(lower(AGENT_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
