/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_GO_BICESS_GENECHIP_A_lwr on AR_GO_BIOLOGICAL_PROCESS(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_BICESS_EVIDENCE_lwr on AR_GO_BIOLOGICAL_PROCESS(lower(EVIDENCE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_BICESS_DESCRIPTIO_lwr on AR_GO_BIOLOGICAL_PROCESS(lower(DESCRIPTION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GO_BICESS_PROBE_SET__lwr on AR_GO_BIOLOGICAL_PROCESS(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
