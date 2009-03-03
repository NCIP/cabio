
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0021124;
alter table MICROARRAY enable constraint SYS_C0016542;
alter table MICROARRAY enable constraint SYS_C0016543;
alter table MICROARRAY enable constraint SYS_C0016544;
alter table MICROARRAY enable constraint SYS_C004599;
alter table MICROARRAY enable constraint SYS_C004600;
alter table MICROARRAY enable constraint MICROARRAY_PK;

alter table MICROARRAY enable primary key;

--EXIT;
create unique index SYS_C0021124_idx on MICROARRAY
(LSID,ACCESSION,DESCRIPTION,TYPE,PLATFORM,DBSNP_VERSION,GENOME_VERSION,ANNOTATION_DATE,ARRAY_NAME) tablespace CABIO_FUT;
alter table MICROARRAY enable constraint SYS_C0021124 using index SYS_C0021124_idx;
create unique index MICROARRAY_PK_idx on MICROARRAY
(ID) tablespace CABIO_FUT;
alter table MICROARRAY enable constraint MICROARRAY_PK using index MICROARRAY_PK_idx;
