/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_MISCGID_EVS_ID on ZSTG_MISSING_AGENT_CGID(EVS_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MISCGID_MATCHING_C on ZSTG_MISSING_AGENT_CGID(MATCHING_CONCEPT) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MISCGID_DRUG on ZSTG_MISSING_AGENT_CGID(DRUG) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
