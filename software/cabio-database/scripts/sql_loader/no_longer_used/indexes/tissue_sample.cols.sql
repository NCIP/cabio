
create index TISSUE_SMPLE_TISSUE_ID on TISSUE_SAMPLE(TISSUE_ID) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_TISSUE_NAM on TISSUE_SAMPLE(TISSUE_NAME) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_ORGAN on TISSUE_SAMPLE(ORGAN) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_SEX on TISSUE_SAMPLE(SEX) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_SUPPLIER on TISSUE_SAMPLE(SUPPLIER) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_HISTOLOGY on TISSUE_SAMPLE(HISTOLOGY) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_DESCRIPTIO on TISSUE_SAMPLE(DESCRIPTION) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_TISSUE_TYP on TISSUE_SAMPLE(TISSUE_TYPE) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_CELL_TYPE on TISSUE_SAMPLE(CELL_TYPE) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_CELL_LINE on TISSUE_SAMPLE(CELL_LINE) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_DEVELOPMEN on TISSUE_SAMPLE(DEVELOPMENT_STAGE) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_SAMPLE_ID on TISSUE_SAMPLE(SAMPLE_ID) PARALLEL NOLOGGING tablespace CABIO;
create index TISSUE_SMPLE_TISSUE_PRO on TISSUE_SAMPLE(TISSUE_PROTOCOL) PARALLEL NOLOGGING tablespace CABIO;

--EXIT;
