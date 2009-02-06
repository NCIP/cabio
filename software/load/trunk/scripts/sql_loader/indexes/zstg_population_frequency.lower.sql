
create index ZSTG_POPENCY_TYPE_lwr on ZSTG_POPULATION_FREQUENCY(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_ETHNICITY_lwr on ZSTG_POPULATION_FREQUENCY(lower(ETHNICITY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MAJOR_ALLE_lwr on ZSTG_POPULATION_FREQUENCY(lower(MAJOR_ALLELE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MINOR_ALLE_lwr on ZSTG_POPULATION_FREQUENCY(lower(MINOR_ALLELE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_SNP_PROBES_lwr on ZSTG_POPULATION_FREQUENCY(lower(SNP_PROBESET_AFFY_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;