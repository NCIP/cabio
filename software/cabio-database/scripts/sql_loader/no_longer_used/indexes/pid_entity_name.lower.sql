
create index PID_ENTINAME_NAME_lwr on PID_ENTITY_NAME(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
