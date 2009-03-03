
alter table PROTEIN_PROTEIN_ALIAS enable constraint SYS_C0021169;
alter table PROTEIN_PROTEIN_ALIAS enable constraint SYS_C0021169;
alter table PROTEIN_PROTEIN_ALIAS enable constraint SYS_C004663;
alter table PROTEIN_PROTEIN_ALIAS enable constraint SYS_C004664;

--EXIT;
create unique index SYS_C0021169_idx on PROTEIN_PROTEIN_ALIAS
(PROTEIN_ALIAS_ID,PROTEIN_ID) tablespace CABIO_FUT;
alter table PROTEIN_PROTEIN_ALIAS enable constraint SYS_C0021169 using index SYS_C0021169_idx;
