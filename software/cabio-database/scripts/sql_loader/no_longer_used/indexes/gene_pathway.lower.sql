
create index GENE_PATHWAY_BC_ID_lwr on GENE_PATHWAY(lower(BC_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
