create unique index NLTV_BK_idx on LOCATION_CH
(ID) tablespace CABIO;
alter table LOCATION_CH enable constraint NLTV_BK using index NLTV_BK_idx;

alter table LOCATION_CH enable constraint SYS_C0021116;
alter table LOCATION_CH enable constraint SYS_C004570;
alter table LOCATION_CH enable constraint SYS_C004571;
alter table LOCATION_CH enable constraint SYS_C004572;
alter table LOCATION_CH enable constraint NLTV_BK;

alter table LOCATION_CH enable primary key;

--EXIT;
