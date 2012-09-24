
create index MARKER_LOKUP_NAME_lwr on MARKER_LOOKUP(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
