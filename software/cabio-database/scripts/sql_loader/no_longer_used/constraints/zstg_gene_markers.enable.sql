create unique index SYS_C0020846_idx on ZSTG_GENE_MARKERS
(MARKER_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_MARKERS enable constraint SYS_C0020846 using index SYS_C0020846_idx;

alter table ZSTG_GENE_MARKERS enable constraint SYS_C0020846;
alter table ZSTG_GENE_MARKERS enable constraint SYS_C0020846;
alter table ZSTG_GENE_MARKERS enable constraint SYS_C004956;
alter table ZSTG_GENE_MARKERS enable constraint SYS_C004957;

alter table ZSTG_GENE_MARKERS enable primary key;

--EXIT;
