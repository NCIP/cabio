
alter table TRANSCRIPT_GENE enable constraint SYS_C004811;
alter table TRANSCRIPT_GENE enable constraint SYS_C004812;
alter table TRANSCRIPT_GENE enable constraint TGPK;
alter table TRANSCRIPT_GENE enable constraint TGPK;

alter table TRANSCRIPT_GENE enable primary key;

--EXIT;
create unique index TGPK_idx on TRANSCRIPT_GENE
(GENE_ID,TRANSCRIPT_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT_GENE enable constraint TGPK using index TGPK_idx;
