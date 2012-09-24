create unique index LOC_TV_PK_idx on LOCATION_TV
(ID) tablespace CABIO_FUT;
alter table LOCATION_TV enable constraint LOC_TV_PK using index LOC_TV_PK_idx;

alter table LOCATION_TV enable constraint SYS_C004574;
alter table LOCATION_TV enable constraint SYS_C004575;
alter table LOCATION_TV enable constraint LOC_TV_PK;

alter table LOCATION_TV enable primary key;

--EXIT;
