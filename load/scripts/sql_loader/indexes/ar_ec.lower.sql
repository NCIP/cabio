
create index AR_ECR_EC_GENECHIP_A_lwr on AR_EC(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ECR_EC_EC_lwr on AR_EC(lower(EC)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ECR_EC_PROBE_SET__lwr on AR_EC(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
