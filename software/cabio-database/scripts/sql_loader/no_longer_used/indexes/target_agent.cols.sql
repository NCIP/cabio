/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TARGET_AGENT_AGENT_ID on TARGET_AGENT(AGENT_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TARGET_AGENT_TARGET_ID on TARGET_AGENT(TARGET_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
