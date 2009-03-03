
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004176;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004177;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004178;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004179;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004180;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004181;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004182;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C004183;

alter table AR_ALIGNMENTS_TMP enable primary key;

--EXIT;
create unique index SYS_C0021039_idx on AR_ALIGNMENTS_TMP
(GENECHIP_ARRAY,ASSEMBLY,TRIM_CHR,DIRECTION,END_POSITION,START_POSITION,CHROMOSOME,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_ALIGNMENTS_TMP enable constraint SYS_C0021039 using index SYS_C0021039_idx;
