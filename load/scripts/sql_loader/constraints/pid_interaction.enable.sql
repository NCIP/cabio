create unique index SYS_C0021154_idx on PID_INTERACTION
(PID_INTERACTION_ID,REF_PATHWAY_ID,MACRO_NAME,SOURCE) tablespace CABIO_FUT;
alter table PID_INTERACTION enable constraint SYS_C0021154 using index SYS_C0021154_idx;
create unique index SYS_C0016505_idx on PID_INTERACTION
(ID) tablespace CABIO_FUT;
alter table PID_INTERACTION enable constraint SYS_C0016505 using index SYS_C0016505_idx;

alter table PID_INTERACTION enable constraint SYS_C0021154;
alter table PID_INTERACTION enable constraint SYS_C0021154;
alter table PID_INTERACTION enable constraint SYS_C0021154;
alter table PID_INTERACTION enable constraint SYS_C0021154;
alter table PID_INTERACTION enable constraint SYS_C0016480;
alter table PID_INTERACTION enable constraint SYS_C0016481;
alter table PID_INTERACTION enable constraint SYS_C0016482;
alter table PID_INTERACTION enable constraint SYS_C0016483;
alter table PID_INTERACTION enable constraint SYS_C0016505;

alter table PID_INTERACTION enable primary key;

--EXIT;
