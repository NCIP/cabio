
create index ZSTG_HUM_EST_CHROMOSOME_lwr on ZSTG_HUMAN_EST(lower(CHROMOSOME_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_HUM_EST_CHROMOSOME_lwr on ZSTG_HUMAN_EST(lower(CHROMOSOME_NO)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_HUM_EST_TNAME_lwr on ZSTG_HUMAN_EST(lower(TNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_HUM_EST_QNAME_lwr on ZSTG_HUMAN_EST(lower(QNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
