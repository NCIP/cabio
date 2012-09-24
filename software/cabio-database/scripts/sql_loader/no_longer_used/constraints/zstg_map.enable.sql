create unique index SYS_C0020881_idx on ZSTG_MAP
(END_CYTOBAND,START_CYTOBAND,CHROMOSOME_NUMBER,CYTOBAND,TAXON_ID,CHROMOSOME_ID,MAP_LOCATION,MAP_TYPE,MAP_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_MAP enable constraint SYS_C0020881 using index SYS_C0020881_idx;

alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C0020881;
alter table ZSTG_MAP enable constraint SYS_C005002;
alter table ZSTG_MAP enable constraint SYS_C005003;
alter table ZSTG_MAP enable constraint SYS_C005004;
alter table ZSTG_MAP enable constraint SYS_C005005;
alter table ZSTG_MAP enable constraint SYS_C005006;
alter table ZSTG_MAP enable constraint SYS_C005007;
alter table ZSTG_MAP enable constraint SYS_C005008;
alter table ZSTG_MAP enable constraint SYS_C005009;
alter table ZSTG_MAP enable constraint SYS_C005010;

alter table ZSTG_MAP enable primary key;

--EXIT;
