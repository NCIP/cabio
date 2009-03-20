create unique index SYS_C0021050_idx on AR_GENE_TITLE_TMP
(GENECHIP_ARRAY,GENE_TITLE,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C0021050 using index SYS_C0021050_idx;

alter table AR_GENE_TITLE_TMP enable constraint SYS_C0021050;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C0021050;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C0021050;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C004225;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C004226;
alter table AR_GENE_TITLE_TMP enable constraint SYS_C004227;

alter table AR_GENE_TITLE_TMP enable primary key;

--EXIT;
