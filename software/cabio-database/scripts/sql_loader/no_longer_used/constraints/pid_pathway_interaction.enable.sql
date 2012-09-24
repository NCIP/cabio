create unique index SYS_C0016509_idx on PID_PATHWAY_INTERACTION
(INTERACTION_ID,PATHWAY_ID) tablespace CABIO_FUT;
alter table PID_PATHWAY_INTERACTION enable constraint SYS_C0016509 using index SYS_C0016509_idx;

alter table PID_PATHWAY_INTERACTION enable constraint SYS_C0016490;
alter table PID_PATHWAY_INTERACTION enable constraint SYS_C0016491;
alter table PID_PATHWAY_INTERACTION enable constraint SYS_C0016509;
alter table PID_PATHWAY_INTERACTION enable constraint SYS_C0016509;

alter table PID_PATHWAY_INTERACTION enable primary key;

--EXIT;
