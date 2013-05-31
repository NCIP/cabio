/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_AGECGID_EVS_ID on ZSTG_AGENT_CGID(EVS_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_AGECGID_DRUG on ZSTG_AGENT_CGID(DRUG) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_AGECGID_ID on ZSTG_AGENT_CGID(ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
