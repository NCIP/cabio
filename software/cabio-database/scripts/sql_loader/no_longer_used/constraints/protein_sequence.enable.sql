create unique index SYS_C0021171_idx on PROTEIN_SEQUENCE
(LENGTH,PROTEIN_ID,CHECKSUM,DALTONWEIGHT) tablespace CABIO_FUT;
alter table PROTEIN_SEQUENCE enable constraint SYS_C0021171 using index SYS_C0021171_idx;
create unique index PS_PK_idx on PROTEIN_SEQUENCE
(ID) tablespace CABIO_FUT;
alter table PROTEIN_SEQUENCE enable constraint PS_PK using index PS_PK_idx;

alter table PROTEIN_SEQUENCE enable constraint SYS_C0021171;
alter table PROTEIN_SEQUENCE enable constraint SYS_C0021171;
alter table PROTEIN_SEQUENCE enable constraint SYS_C0021171;
alter table PROTEIN_SEQUENCE enable constraint SYS_C0021171;
alter table PROTEIN_SEQUENCE enable constraint SYS_C004670;
alter table PROTEIN_SEQUENCE enable constraint SYS_C004671;
alter table PROTEIN_SEQUENCE enable constraint SYS_C004672;
alter table PROTEIN_SEQUENCE enable constraint SYS_C004673;
alter table PROTEIN_SEQUENCE enable constraint SYS_C004674;
alter table PROTEIN_SEQUENCE enable constraint PS_PK;

alter table PROTEIN_SEQUENCE enable primary key;

--EXIT;
