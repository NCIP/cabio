/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_UNIGEE_ID_GENECHIP_A on AR_UNIGENE_ID(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_UNIGEE_ID_UNIGENE_ID on AR_UNIGENE_ID(UNIGENE_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_UNIGEE_ID_PROBE_SET_ on AR_UNIGENE_ID(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
