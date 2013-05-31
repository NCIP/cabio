/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_ECR_EC_GENECHIP_A on AR_EC(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ECR_EC_EC on AR_EC(EC) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ECR_EC_PROBE_SET_ on AR_EC(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
