create unique index SYS_C0021104_idx on GENE_RELATIVE_LOCATION
(TYPE,PROBE_SET_ID,SNP_ID,GENE_ID,DISTANCE,ORIENTATION) tablespace CABIO_FUT;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104 using index SYS_C0021104_idx;
create unique index GENE_REL_PK_idx on GENE_RELATIVE_LOCATION
(ID) tablespace CABIO_FUT;
alter table GENE_RELATIVE_LOCATION enable constraint GENE_REL_PK using index GENE_REL_PK_idx;

alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004489;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004490;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004491;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004492;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004493;
alter table GENE_RELATIVE_LOCATION enable constraint SYS_C004494;
alter table GENE_RELATIVE_LOCATION enable constraint GENE_REL_PK;

alter table GENE_RELATIVE_LOCATION enable primary key;

--EXIT;
