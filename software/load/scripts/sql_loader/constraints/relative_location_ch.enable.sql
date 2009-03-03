
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH enable constraint REL_LOC_CH_PK;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C004718;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C004719;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C004720;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C004721;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C004722;

alter table RELATIVE_LOCATION_CH enable primary key;

--EXIT;
create unique index SYS_C0021179_idx on RELATIVE_LOCATION_CH
(DISCRIMINATOR,GENE_ID,PROBE_SET_ID,SNP_ID,DISTANCE,ORIENTATION,TYPE) tablespace CABIO_FUT;
alter table RELATIVE_LOCATION_CH enable constraint SYS_C0021179 using index SYS_C0021179_idx;
create unique index REL_LOC_CH_PK_idx on RELATIVE_LOCATION_CH
(ID) tablespace CABIO_FUT;
alter table RELATIVE_LOCATION_CH enable constraint REL_LOC_CH_PK using index REL_LOC_CH_PK_idx;
