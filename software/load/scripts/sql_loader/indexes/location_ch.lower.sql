
create index LOCATIONN_CH_ASSEMBLY_lwr on LOCATION_CH(lower(ASSEMBLY)) PARALLEL NOLOGGING tablespace cabio_fut;
create index LOCATIONN_CH_FEATURE_TY_lwr on LOCATION_CH(lower(FEATURE_TYPE)) PARALLEL NOLOGGING tablespace cabio_fut;
create index LOCATIONN_CH_DISCRIMINA_lwr on LOCATION_CH(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace cabio_fut;

--EXIT;
