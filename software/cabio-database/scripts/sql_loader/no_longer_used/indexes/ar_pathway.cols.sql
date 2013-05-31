/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_PATHWHWAY_GENECHIP_A on AR_PATHWAY(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHWHWAY_PATHWAY on AR_PATHWAY(PATHWAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_PATHWHWAY_PROBE_SET_ on AR_PATHWAY(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
