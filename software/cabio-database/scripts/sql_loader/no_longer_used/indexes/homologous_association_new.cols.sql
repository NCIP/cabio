
create index HOMOLOGOUS_AS_ID on HOMOLOGOUS_ASSOCIATION_NEW(ID) tablespace CABIO_MAP_FUT;
create index HOMOLOGOUS_AS_SIMILARITY_PERC on HOMOLOGOUS_ASSOCIATION_NEW(SIMILARITY_PERCENTAGE) tablespace CABIO_MAP_FUT;
create index HOMOLOGOUS_AS_HOMOLOGOUS_ID on HOMOLOGOUS_ASSOCIATION_NEW(HOMOLOGOUS_ID) tablespace CABIO_MAP_FUT;
create index HOMOLOGOUS_AS_HOMOLOGOUS_GENE on HOMOLOGOUS_ASSOCIATION_NEW(HOMOLOGOUS_GENE_ID) tablespace CABIO_MAP_FUT;

--EXIT;
