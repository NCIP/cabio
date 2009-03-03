
alter table EXON enable constraint SYS_C0021091;
alter table EXON enable constraint SYS_C0021091;
alter table EXON enable constraint SYS_C0021091;
alter table EXON enable constraint SYS_C004416;
alter table EXON enable constraint SYS_C004417;
alter table EXON enable constraint SYS_C004418;
alter table EXON enable constraint SYS_C004419;
alter table EXON enable constraint EXON_PK;

alter table EXON enable primary key;

--EXIT;
create unique index SYS_C0021091_idx on EXON
(TRANSCRIPT_ID,SOURCE,MANUFACTURER_ID) tablespace CABIO_FUT;
alter table EXON enable constraint SYS_C0021091 using index SYS_C0021091_idx;
create unique index EXON_PK_idx on EXON
(ID) tablespace CABIO_FUT;
alter table EXON enable constraint EXON_PK using index EXON_PK_idx;
