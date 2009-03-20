create unique index SYS_C0021069_idx on AR_UNIGENE_ID
(GENECHIP_ARRAY,UNIGENE_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_UNIGENE_ID enable constraint SYS_C0021069 using index SYS_C0021069_idx;

alter table AR_UNIGENE_ID enable constraint SYS_C0021069;
alter table AR_UNIGENE_ID enable constraint SYS_C0021069;
alter table AR_UNIGENE_ID enable constraint SYS_C0021069;
alter table AR_UNIGENE_ID enable constraint SYS_C004304;
alter table AR_UNIGENE_ID enable constraint SYS_C004305;
alter table AR_UNIGENE_ID enable constraint SYS_C004306;

alter table AR_UNIGENE_ID enable primary key;

--EXIT;
