create unique index SYS_C0021076_idx on CLONE_TV
(TYPE,LIBRARY_ID,INSERT_SIZE,CLONE_NAME) tablespace CABIO_FUT;
alter table CLONE_TV enable constraint SYS_C0021076 using index SYS_C0021076_idx;
create unique index CLONE_TV_PK_idx on CLONE_TV
(CLONE_ID) tablespace CABIO_FUT;
alter table CLONE_TV enable constraint CLONE_TV_PK using index CLONE_TV_PK_idx;
create unique index CLONENODUPS_idx on CLONE_TV
(LIBRARY_ID,CLONE_NAME) tablespace CABIO_FUT;
alter table CLONE_TV enable constraint CLONENODUPS using index CLONENODUPS_idx;

alter table CLONE_TV enable constraint SYS_C0021076;
alter table CLONE_TV enable constraint SYS_C0021076;
alter table CLONE_TV enable constraint SYS_C0021076;
alter table CLONE_TV enable constraint SYS_C0021076;
alter table CLONE_TV enable constraint SYS_C004349;
alter table CLONE_TV enable constraint SYS_C004350;
alter table CLONE_TV enable constraint SYS_C004351;
alter table CLONE_TV enable constraint CLONE_TV_PK;
alter table CLONE_TV enable constraint CLONENODUPS;
alter table CLONE_TV enable constraint CLONENODUPS;

alter table CLONE_TV enable primary key;

--EXIT;
