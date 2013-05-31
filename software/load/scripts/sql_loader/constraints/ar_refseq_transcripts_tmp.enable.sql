/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021064_idx on AR_REFSEQ_TRANSCRIPTS_TMP
(GENECHIP_ARRAY,REFSEQ_TRANSCRIPTS_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C0021064 using index SYS_C0021064_idx;

alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C0021064;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C0021064;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C0021064;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C004279;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C004280;
alter table AR_REFSEQ_TRANSCRIPTS_TMP enable constraint SYS_C004281;

alter table AR_REFSEQ_TRANSCRIPTS_TMP enable primary key;

--EXIT;
