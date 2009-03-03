
alter table ZSTG_GENE_AGENT_CGID enable constraint SYS_C004936;
alter table ZSTG_GENE_AGENT_CGID enable constraint SYS_C004937;
alter table ZSTG_GENE_AGENT_CGID enable constraint SYS_C0020839;
alter table ZSTG_GENE_AGENT_CGID enable constraint SYS_C0020839;

alter table ZSTG_GENE_AGENT_CGID enable primary key;

--EXIT;
create unique index SYS_C0020839_idx on ZSTG_GENE_AGENT_CGID
(AGENT_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_AGENT_CGID enable constraint SYS_C0020839 using index SYS_C0020839_idx;
