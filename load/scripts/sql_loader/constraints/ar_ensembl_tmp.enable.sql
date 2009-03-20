create unique index SYS_C0021044_idx on AR_ENSEMBL_TMP
(GENECHIP_ARRAY,ENSEMBL_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_ENSEMBL_TMP enable constraint SYS_C0021044 using index SYS_C0021044_idx;

alter table AR_ENSEMBL_TMP enable constraint SYS_C0021044;
alter table AR_ENSEMBL_TMP enable constraint SYS_C0021044;
alter table AR_ENSEMBL_TMP enable constraint SYS_C0021044;
alter table AR_ENSEMBL_TMP enable constraint SYS_C004207;
alter table AR_ENSEMBL_TMP enable constraint SYS_C004208;
alter table AR_ENSEMBL_TMP enable constraint SYS_C004209;

alter table AR_ENSEMBL_TMP enable primary key;

--EXIT;
