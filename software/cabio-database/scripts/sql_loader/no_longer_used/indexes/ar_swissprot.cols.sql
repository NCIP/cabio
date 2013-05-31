/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_SWISSPROT_GENECHIP_A on AR_SWISSPROT(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_SWISSPROT_SWISSPROT_ on AR_SWISSPROT(SWISSPROT_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_SWISSPROT_PROBE_SET_ on AR_SWISSPROT(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
