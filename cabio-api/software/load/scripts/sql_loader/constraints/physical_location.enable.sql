create unique index PL_PK_idx on PHYSICAL_LOCATION
(ID) tablespace CABIO_FUT;
alter table PHYSICAL_LOCATION enable constraint PL_PK using index PL_PK_idx;

alter table PHYSICAL_LOCATION enable constraint SYS_C004636;
alter table PHYSICAL_LOCATION enable constraint PL_PK;
alter table PHYSICAL_LOCATION enable constraint SYS_C004633;
alter table PHYSICAL_LOCATION enable constraint SYS_C004634;
alter table PHYSICAL_LOCATION enable constraint SYS_C004635;

alter table PHYSICAL_LOCATION enable primary key;

--EXIT;
