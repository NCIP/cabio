/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_REFSEQ_TRANSCRIPTS disable constraint SYS_C004276;
alter table AR_REFSEQ_TRANSCRIPTS disable constraint SYS_C004277;
alter table AR_REFSEQ_TRANSCRIPTS disable constraint SYS_C004278;

alter table AR_REFSEQ_TRANSCRIPTS disable primary key;

--EXIT;
