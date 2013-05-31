/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index TGPK_idx on TRANSCRIPT_GENE
(GENE_ID,TRANSCRIPT_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT_GENE enable constraint TGPK using index TGPK_idx;

alter table TRANSCRIPT_GENE enable constraint SYS_C004811;
alter table TRANSCRIPT_GENE enable constraint SYS_C004812;
alter table TRANSCRIPT_GENE enable constraint TGPK;
alter table TRANSCRIPT_GENE enable constraint TGPK;

alter table TRANSCRIPT_GENE enable primary key;

--EXIT;
