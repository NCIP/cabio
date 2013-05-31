/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_AGE_NSC_AGENT_NAME_lwr on ZSTG_AGENTS_NSC(lower(AGENT_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
