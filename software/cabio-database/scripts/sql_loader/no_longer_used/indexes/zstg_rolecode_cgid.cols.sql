
create index ZSTG_ROLCGID_ID on ZSTG_ROLECODE_CGID(ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_ROLCGID_ROLECODE on ZSTG_ROLECODE_CGID(ROLECODE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
