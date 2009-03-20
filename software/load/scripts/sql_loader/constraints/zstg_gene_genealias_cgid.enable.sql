create unique index SYS_C0020843_idx on ZSTG_GENE_GENEALIAS_CGID
(ALIAS,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_GENEALIAS_CGID enable constraint SYS_C0020843 using index SYS_C0020843_idx;

alter table ZSTG_GENE_GENEALIAS_CGID enable constraint SYS_C0020843;
alter table ZSTG_GENE_GENEALIAS_CGID enable constraint SYS_C0020843;
alter table ZSTG_GENE_GENEALIAS_CGID enable constraint SYS_C004472;
alter table ZSTG_GENE_GENEALIAS_CGID enable constraint SYS_C004473;

alter table ZSTG_GENE_GENEALIAS_CGID enable primary key;

--EXIT;
