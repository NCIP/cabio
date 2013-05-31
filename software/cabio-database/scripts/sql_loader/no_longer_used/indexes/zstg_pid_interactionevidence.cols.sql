/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDENCE_EVIDENCE_C on ZSTG_PID_INTERACTIONEVIDENCE(EVIDENCE_CODE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDENCE_INTERACTIO on ZSTG_PID_INTERACTIONEVIDENCE(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
