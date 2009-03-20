create unique index SYS_C0021048_idx on AR_GENE_SYMBOL_TMP
(GENECHIP_ARRAY,GENE_SYMBOL,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C0021048 using index SYS_C0021048_idx;

alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C0021048;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C0021048;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C0021048;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C004219;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C004220;
alter table AR_GENE_SYMBOL_TMP enable constraint SYS_C004221;

alter table AR_GENE_SYMBOL_TMP enable primary key;

--EXIT;
