
create index ZSTG_PIDTION_XREF_lwr on ZSTG_PID_INTERACTIONCONDITION(lower(XREF)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_CONDITIONN_lwr on ZSTG_PID_INTERACTIONCONDITION(lower(CONDITIONNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
