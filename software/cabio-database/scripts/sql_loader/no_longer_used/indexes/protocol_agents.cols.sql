/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTOCOLENTS_AGENT_ID on PROTOCOL_AGENTS(AGENT_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTOCOLENTS_PRO_ID on PROTOCOL_AGENTS(PRO_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
