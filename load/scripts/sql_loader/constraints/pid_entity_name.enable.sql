
alter table PID_ENTITY_NAME enable constraint SYS_C0016471;
alter table PID_ENTITY_NAME enable constraint SYS_C0016472;
alter table PID_ENTITY_NAME enable constraint SYS_C0016473;
alter table PID_ENTITY_NAME enable constraint SYS_C0021150;
alter table PID_ENTITY_NAME enable constraint SYS_C0021150;
alter table PID_ENTITY_NAME enable constraint SYS_C0016501;

alter table PID_ENTITY_NAME enable primary key;

--EXIT;
create unique index SYS_C0021150_idx on PID_ENTITY_NAME
(PID_PHYSICALENTITY_ID,NAME) tablespace CABIO_FUT;
alter table PID_ENTITY_NAME enable constraint SYS_C0021150 using index SYS_C0021150_idx;
create unique index SYS_C0016501_idx on PID_ENTITY_NAME
(ID) tablespace CABIO_FUT;
alter table PID_ENTITY_NAME enable constraint SYS_C0016501 using index SYS_C0016501_idx;
