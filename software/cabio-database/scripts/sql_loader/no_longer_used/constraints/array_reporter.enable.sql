create unique index SYS_C0021036_idx on ARRAY_REPORTER
(MICROARRAY_ID,NAME) tablespace CABIO_FUT;
alter table ARRAY_REPORTER enable constraint SYS_C0021036 using index SYS_C0021036_idx;
create unique index REPORTER_PK_idx on ARRAY_REPORTER
(ID) tablespace CABIO_FUT;
alter table ARRAY_REPORTER enable constraint REPORTER_PK using index REPORTER_PK_idx;

alter table ARRAY_REPORTER enable constraint SYS_C0021036;
alter table ARRAY_REPORTER enable constraint SYS_C0021036;
alter table ARRAY_REPORTER enable constraint SYS_C004158;
alter table ARRAY_REPORTER enable constraint SYS_C004159;
alter table ARRAY_REPORTER enable constraint SYS_C004160;
alter table ARRAY_REPORTER enable constraint REPORTER_PK;

alter table ARRAY_REPORTER enable primary key;

--EXIT;
