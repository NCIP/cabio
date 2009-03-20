create unique index SYS_C0016506_idx on PID_INTERACTION_EC
(EVIDENCE_CODE_ID,INTERACTION_ID) tablespace CABIO_FUT;
alter table PID_INTERACTION_EC enable constraint SYS_C0016506 using index SYS_C0016506_idx;

alter table PID_INTERACTION_EC enable constraint SYS_C0016484;
alter table PID_INTERACTION_EC enable constraint SYS_C0016485;
alter table PID_INTERACTION_EC enable constraint SYS_C0016506;
alter table PID_INTERACTION_EC enable constraint SYS_C0016506;

alter table PID_INTERACTION_EC enable primary key;

--EXIT;
