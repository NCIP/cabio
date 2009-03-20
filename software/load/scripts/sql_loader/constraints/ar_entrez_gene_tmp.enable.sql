create unique index SYS_C0021046_idx on AR_ENTREZ_GENE_TMP
(GENECHIP_ARRAY,ENTREZ_GENE,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C0021046 using index SYS_C0021046_idx;

alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C0021046;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C0021046;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C0021046;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C004213;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C004214;
alter table AR_ENTREZ_GENE_TMP enable constraint SYS_C004215;

alter table AR_ENTREZ_GENE_TMP enable primary key;

--EXIT;
