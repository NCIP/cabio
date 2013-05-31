/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_PATHWHWAY_GENECHIP_A_lwr on AR_PATHWAY(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHWHWAY_PATHWAY_lwr on AR_PATHWAY(lower(PATHWAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHWHWAY_PROBE_SET__lwr on AR_PATHWAY(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
