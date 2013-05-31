/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021063_idx on AR_REFSEQ_TRANSCRIPTS
(GENECHIP_ARRAY,REFSEQ_TRANSCRIPTS_ID,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C0021063 using index SYS_C0021063_idx;

alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C0021063;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C0021063;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C0021063;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C004276;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C004277;
alter table AR_REFSEQ_TRANSCRIPTS enable constraint SYS_C004278;

alter table AR_REFSEQ_TRANSCRIPTS enable primary key;

--EXIT;
