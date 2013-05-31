/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_GO_CENENT_GENECHIP_A_lwr on AR_GO_CELLULAR_COMPONENT(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_CENENT_EVIDENCE_lwr on AR_GO_CELLULAR_COMPONENT(lower(EVIDENCE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_CENENT_DESCRIPTIO_lwr on AR_GO_CELLULAR_COMPONENT(lower(DESCRIPTION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_CENENT_PROBE_SET__lwr on AR_GO_CELLULAR_COMPONENT(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
