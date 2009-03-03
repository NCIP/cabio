
alter table CGAP_GENE_ALIAS enable constraint SYS_C004325;
alter table CGAP_GENE_ALIAS enable constraint SYS_C004326;
alter table CGAP_GENE_ALIAS enable constraint CGAPK;
alter table CGAP_GENE_ALIAS enable constraint CGAPK;

alter table CGAP_GENE_ALIAS enable primary key;

--EXIT;
create unique index CGAPK_idx on CGAP_GENE_ALIAS
(ALIAS,GENE_ID) tablespace CABIO_FUT;
alter table CGAP_GENE_ALIAS enable constraint CGAPK using index CGAPK_idx;
