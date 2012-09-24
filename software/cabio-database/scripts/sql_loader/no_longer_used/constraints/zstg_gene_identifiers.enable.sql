create unique index SYS_C0020845_idx on ZSTG_GENE_IDENTIFIERS
(IDENTIFIER,DATA_SOURCE,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C0020845 using index SYS_C0020845_idx;

alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C0020845;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C0020845;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C0020845;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C004952;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C004953;
alter table ZSTG_GENE_IDENTIFIERS enable constraint SYS_C004954;

alter table ZSTG_GENE_IDENTIFIERS enable primary key;

--EXIT;
