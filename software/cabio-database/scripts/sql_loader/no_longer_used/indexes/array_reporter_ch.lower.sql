/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ARRAY_RER_CH_STRAND_lwr on ARRAY_REPORTER_CH(lower(STRAND)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_PROBE_COUN_lwr on ARRAY_REPORTER_CH(lower(PROBE_COUNT)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_MANUFACTUR_lwr on ARRAY_REPORTER_CH(lower(MANUFACTURER_PSR_ID)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_PHAST_CONS_lwr on ARRAY_REPORTER_CH(lower(PHAST_CONSERVATION)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_TARGET_DES_lwr on ARRAY_REPORTER_CH(lower(TARGET_DESCRIPTION)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_TARGET_ID_lwr on ARRAY_REPORTER_CH(lower(TARGET_ID)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_SEQUENCE_S_lwr on ARRAY_REPORTER_CH(lower(SEQUENCE_SOURCE)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_SEQUENCE_T_lwr on ARRAY_REPORTER_CH(lower(SEQUENCE_TYPE)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_DISCRIMINA_lwr on ARRAY_REPORTER_CH(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace cabio_fut;
create index ARRAY_RER_CH_NAME_lwr on ARRAY_REPORTER_CH(lower(NAME)) PARALLEL NOLOGGING tablespace cabio_fut;

--EXIT;
