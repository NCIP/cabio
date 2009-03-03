
create index ZSTG_PATENTS_INTERACTIO on ZSTG_PATHWAYCOMPONENTS(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATENTS_SOURCE_ID on ZSTG_PATHWAYCOMPONENTS(SOURCE_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATENTS_PATHWAY_ID on ZSTG_PATHWAYCOMPONENTS(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
