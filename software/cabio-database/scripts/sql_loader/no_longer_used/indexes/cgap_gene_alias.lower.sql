
create index CGAP_GENLIAS_ALIAS_lwr on CGAP_GENE_ALIAS(lower(ALIAS)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
