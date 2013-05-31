/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDENCE_EVIDENCE_C_lwr on ZSTG_PID_INTERACTIONEVIDENCE(lower(EVIDENCE_CODE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
