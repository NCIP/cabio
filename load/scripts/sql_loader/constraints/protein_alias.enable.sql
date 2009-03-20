create unique index SYS_C0021164_idx on PROTEIN_ALIAS
(NAME,PROTEIN_ID) tablespace CABIO_FUT;
alter table PROTEIN_ALIAS enable constraint SYS_C0021164 using index SYS_C0021164_idx;
create unique index PAPK_idx on PROTEIN_ALIAS
(ID) tablespace CABIO_FUT;
alter table PROTEIN_ALIAS enable constraint PAPK using index PAPK_idx;

alter table PROTEIN_ALIAS enable constraint SYS_C0021164;
alter table PROTEIN_ALIAS enable constraint SYS_C0021164;
alter table PROTEIN_ALIAS enable constraint SYS_C004648;
alter table PROTEIN_ALIAS enable constraint SYS_C004649;
alter table PROTEIN_ALIAS enable constraint SYS_C004650;
alter table PROTEIN_ALIAS enable constraint PAPK;

alter table PROTEIN_ALIAS enable primary key;

--EXIT;
