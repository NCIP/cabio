/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_REFSE_TMP_GENECHIP_A_lwr on AR_REFSEQ_TRANSCRIPTS_TMP(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_REFSE_TMP_REFSEQ_TRA_lwr on AR_REFSEQ_TRANSCRIPTS_TMP(lower(REFSEQ_TRANSCRIPTS_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_REFSE_TMP_PROBE_SET__lwr on AR_REFSEQ_TRANSCRIPTS_TMP(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
