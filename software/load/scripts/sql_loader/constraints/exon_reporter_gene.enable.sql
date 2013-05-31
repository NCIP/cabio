/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016536_idx on EXON_REPORTER_GENE
(GENE_ID,EXON_REPORTER_ID) tablespace CABIO_FUT;
alter table EXON_REPORTER_GENE enable constraint SYS_C0016536 using index SYS_C0016536_idx;

alter table EXON_REPORTER_GENE enable constraint SYS_C0016536;
alter table EXON_REPORTER_GENE enable constraint SYS_C0016536;
alter table EXON_REPORTER_GENE enable constraint SYS_C004432;
alter table EXON_REPORTER_GENE enable constraint SYS_C004433;

alter table EXON_REPORTER_GENE enable primary key;

--EXIT;
