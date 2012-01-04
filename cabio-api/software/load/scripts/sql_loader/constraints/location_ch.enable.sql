create unique index LCH_PK_idx on LOCATION_CH
(ID) tablespace CABIO_FUT;
alter table LOCATION_CH enable constraint LCH_PK using index LCH_PK_idx;

alter table LOCATION_CH enable constraint SYS_C0035927;
alter table LOCATION_CH enable constraint SYS_C0035926;
alter table LOCATION_CH enable constraint SYS_C0035928;
alter table LOCATION_CH enable constraint SYS_C0035929;
alter table LOCATION_CH enable constraint LCH_PK;

alter table LOCATION_CH enable primary key;

--EXIT;
