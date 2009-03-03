
create index AR_GENE__TMP_GENECHIP_A_lwr on AR_GENE_SYMBOL_TMP(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GENE__TMP_GENE_SYMBO_lwr on AR_GENE_SYMBOL_TMP(lower(GENE_SYMBOL)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GENE__TMP_PROBE_SET__lwr on AR_GENE_SYMBOL_TMP(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
