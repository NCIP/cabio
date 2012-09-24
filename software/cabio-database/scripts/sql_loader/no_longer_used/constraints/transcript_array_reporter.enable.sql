create unique index SYS_C0021193_idx on TRANSCRIPT_ARRAY_REPORTER
(MICROARRAY_ID,NAME) tablespace CABIO_FUT;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C0021193 using index SYS_C0021193_idx;
create unique index TRANSCRIPT_REPORTER_PK_idx on TRANSCRIPT_ARRAY_REPORTER
(ID) tablespace CABIO_FUT;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint TRANSCRIPT_REPORTER_PK using index TRANSCRIPT_REPORTER_PK_idx;

alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C0021193;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C0021193;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C004805;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C004806;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C004807;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint TRANSCRIPT_REPORTER_PK;

alter table TRANSCRIPT_ARRAY_REPORTER enable primary key;

--EXIT;
