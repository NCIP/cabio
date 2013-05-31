/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index RELATIVEN_CH_DISCRIMINA_lwr on RELATIVE_LOCATION_CH(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVEN_CH_PROBE_SET__lwr on RELATIVE_LOCATION_CH(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVEN_CH_DISTANCE_lwr on RELATIVE_LOCATION_CH(lower(DISTANCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVEN_CH_ORIENTATIO_lwr on RELATIVE_LOCATION_CH(lower(ORIENTATION)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVEN_CH_TYPE_lwr on RELATIVE_LOCATION_CH(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
