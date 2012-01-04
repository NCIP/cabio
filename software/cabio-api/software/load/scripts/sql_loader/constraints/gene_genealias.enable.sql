create unique index SYS_C0020834_idx on GENE_GENEALIAS
(GENE_ALIAS_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_GENEALIAS enable constraint SYS_C0020834 using index SYS_C0020834_idx;

alter table GENE_GENEALIAS enable constraint SYS_C0016566;
alter table GENE_GENEALIAS enable constraint SYS_C0020834;
alter table GENE_GENEALIAS enable constraint SYS_C0020834;
alter table GENE_GENEALIAS enable constraint SYS_C004470;

alter table GENE_GENEALIAS enable primary key;

--EXIT;
