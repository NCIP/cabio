create unique index SYS_C0021066_idx on AR_REP_PUBLIC_ID_TMP
(GENECHIP_ARRAY,REPRESENTATIVE_PUBLIC_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C0021066 using index SYS_C0021066_idx;

alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C0021066;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C0021066;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C0021066;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C004285;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C004286;
alter table AR_REP_PUBLIC_ID_TMP enable constraint SYS_C004287;

alter table AR_REP_PUBLIC_ID_TMP enable primary key;

--EXIT;
