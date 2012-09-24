create unique index GRGPPK_idx on GENERIC_ARRAY_GENERIC_REPORTER
(GENERIC_REPORTER_ID,GENERIC_ARRAY_ID) tablespace CABIO_FUT;
alter table GENERIC_ARRAY_GENERIC_REPORTER enable constraint GRGPPK using index GRGPPK_idx;

alter table GENERIC_ARRAY_GENERIC_REPORTER enable constraint GRGPPK;
alter table GENERIC_ARRAY_GENERIC_REPORTER enable constraint GRGPPK;

alter table GENERIC_ARRAY_GENERIC_REPORTER enable primary key;

--EXIT;
