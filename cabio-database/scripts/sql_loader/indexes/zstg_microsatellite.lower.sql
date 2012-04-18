
create index ZSTG_MICLITE_RELATIVE_P_lwr on ZSTG_MICROSATELLITE(lower(RELATIVE_POSITION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MICLITE_MARKER_lwr on ZSTG_MICROSATELLITE(lower(MARKER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MICLITE_PROBE_SET__lwr on ZSTG_MICROSATELLITE(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;