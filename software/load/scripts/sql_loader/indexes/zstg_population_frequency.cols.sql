
create index ZSTG_POPENCY_SNP_PROBES on ZSTG_POPULATION_FREQUENCY(SNP_PROBESET_AFFY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MINOR_ALLE on ZSTG_POPULATION_FREQUENCY(MINOR_ALLELE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MAJOR_ALLE on ZSTG_POPULATION_FREQUENCY(MAJOR_ALLELE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_SNP_ID on ZSTG_POPULATION_FREQUENCY(SNP_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_HETEROZYGO on ZSTG_POPULATION_FREQUENCY(HETEROZYGOUS_FREQUENCY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MINOR_FREQ on ZSTG_POPULATION_FREQUENCY(MINOR_FREQUENCY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_MAJOR_FREQ on ZSTG_POPULATION_FREQUENCY(MAJOR_FREQUENCY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_ETHNICITY on ZSTG_POPULATION_FREQUENCY(ETHNICITY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_TYPE on ZSTG_POPULATION_FREQUENCY(TYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_ID on ZSTG_POPULATION_FREQUENCY(ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
