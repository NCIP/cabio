
create index MARKER_ALIAS_NAME_lwr on MARKER_ALIAS(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
