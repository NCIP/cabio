
create index GO_ONTOLLOGY_GO_NAME_lwr on GO_ONTOLOGY(lower(GO_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
