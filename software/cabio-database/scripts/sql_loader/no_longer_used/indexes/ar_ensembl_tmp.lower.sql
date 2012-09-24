
create index AR_ENSEM_TMP_GENECHIP_A_lwr on AR_ENSEMBL_TMP(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENSEM_TMP_ENSEMBL_ID_lwr on AR_ENSEMBL_TMP(lower(ENSEMBL_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENSEM_TMP_PROBE_SET__lwr on AR_ENSEMBL_TMP(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
