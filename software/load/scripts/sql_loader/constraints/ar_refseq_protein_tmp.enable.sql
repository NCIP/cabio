
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C0021062;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C0021062;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C0021062;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C004273;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C004274;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C004275;

alter table AR_REFSEQ_PROTEIN_TMP enable primary key;

--EXIT;
create unique index SYS_C0021062_idx on AR_REFSEQ_PROTEIN_TMP
(GENECHIP_ARRAY,REFSEQ_PROTEIN_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_REFSEQ_PROTEIN_TMP enable constraint SYS_C0021062 using index SYS_C0021062_idx;
