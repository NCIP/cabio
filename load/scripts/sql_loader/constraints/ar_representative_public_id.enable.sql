
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C0021065;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C0021065;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C0021065;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C004282;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C004283;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C004284;

alter table AR_REPRESENTATIVE_PUBLIC_ID enable primary key;

--EXIT;
create unique index SYS_C0021065_idx on AR_REPRESENTATIVE_PUBLIC_ID
(GENECHIP_ARRAY,REPRESENTATIVE_PUBLIC_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_REPRESENTATIVE_PUBLIC_ID enable constraint SYS_C0021065 using index SYS_C0021065_idx;
