
create index PROTEIN_LIAS_NAME_lwr on PROTEIN_ALIAS(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
