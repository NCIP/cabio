
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C0021070;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C0021070;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C0021070;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C004307;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C004308;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C004309;

alter table AR_UNIGENE_ID_TMP enable primary key;

--EXIT;
create unique index SYS_C0021070_idx on AR_UNIGENE_ID_TMP
(GENECHIP_ARRAY,UNIGENE_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_UNIGENE_ID_TMP enable constraint SYS_C0021070 using index SYS_C0021070_idx;
