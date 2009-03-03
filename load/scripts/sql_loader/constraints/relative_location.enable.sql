
alter table RELATIVE_LOCATION enable constraint SYS_C004713;
alter table RELATIVE_LOCATION enable constraint SYS_C004714;
alter table RELATIVE_LOCATION enable constraint SYS_C004715;
alter table RELATIVE_LOCATION enable constraint REL_LOCATION_PK;

alter table RELATIVE_LOCATION enable primary key;

--EXIT;
create unique index REL_LOCATION_PK_idx on RELATIVE_LOCATION
(ID) tablespace CABIO_FUT;
alter table RELATIVE_LOCATION enable constraint REL_LOCATION_PK using index REL_LOCATION_PK_idx;
