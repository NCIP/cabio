
create index CYTOBANDBAND_NAME_lwr on CYTOBAND(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
