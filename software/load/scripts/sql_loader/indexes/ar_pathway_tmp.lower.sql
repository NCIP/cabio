/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_PATHW_TMP_GENECHIP_A_lwr on AR_PATHWAY_TMP(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHW_TMP_PATHWAY_lwr on AR_PATHWAY_TMP(lower(PATHWAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHW_TMP_PROBE_SET__lwr on AR_PATHWAY_TMP(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
