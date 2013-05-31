/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_PATHW_TMP_GENECHIP_A on AR_PATHWAY_TMP(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHW_TMP_PATHWAY on AR_PATHWAY_TMP(PATHWAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHW_TMP_PROBE_SET_ on AR_PATHWAY_TMP(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
