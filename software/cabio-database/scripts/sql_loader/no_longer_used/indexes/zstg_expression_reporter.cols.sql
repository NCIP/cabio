
create index ZSTG_EXPRTER_ASSEMBLY on ZSTG_EXPRESSION_REPORTER(ASSEMBLY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_CYTO_STOP on ZSTG_EXPRESSION_REPORTER(CYTO_STOP) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_CYTO_START on ZSTG_EXPRESSION_REPORTER(CYTO_START) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_CHR_STOP on ZSTG_EXPRESSION_REPORTER(CHR_STOP) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_CHR_START on ZSTG_EXPRESSION_REPORTER(CHR_START) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_CHROMOSOME on ZSTG_EXPRESSION_REPORTER(CHROMOSOME_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_NAS_ID on ZSTG_EXPRESSION_REPORTER(NAS_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_GENE_ID on ZSTG_EXPRESSION_REPORTER(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_TARGET_DES on ZSTG_EXPRESSION_REPORTER(TARGET_DESCRIPTION) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_TRANSCRIPT on ZSTG_EXPRESSION_REPORTER(TRANSCRIPT_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_SEQUENCE_S on ZSTG_EXPRESSION_REPORTER(SEQUENCE_SOURCE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_SEQUENCE_T on ZSTG_EXPRESSION_REPORTER(SEQUENCE_TYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_MICROARRAY on ZSTG_EXPRESSION_REPORTER(MICROARRAY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_NAME on ZSTG_EXPRESSION_REPORTER(NAME) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXPRTER_ID on ZSTG_EXPRESSION_REPORTER(ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
