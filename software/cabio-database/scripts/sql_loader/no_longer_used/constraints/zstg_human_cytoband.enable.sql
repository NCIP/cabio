create unique index CYTOBAND_UNIQ_idx on ZSTG_HUMAN_CYTOBAND
(CYTOBAND) tablespace CABIO_MAP_FUT;
alter table ZSTG_HUMAN_CYTOBAND enable constraint CYTOBAND_UNIQ using index CYTOBAND_UNIQ_idx;
create unique index ZHCPK_idx on ZSTG_HUMAN_CYTOBAND
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_HUMAN_CYTOBAND enable constraint ZHCPK using index ZHCPK_idx;

alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004972;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004973;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004974;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004975;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004976;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004977;
alter table ZSTG_HUMAN_CYTOBAND enable constraint CYTOBAND_UNIQ;
alter table ZSTG_HUMAN_CYTOBAND enable constraint ZHCPK;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004969;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004970;
alter table ZSTG_HUMAN_CYTOBAND enable constraint SYS_C004971;

alter table ZSTG_HUMAN_CYTOBAND enable primary key;

--EXIT;
