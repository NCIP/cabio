/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021092_idx on EXON_REPORTER
(EXON_ID,TRANSCRIPT_ID,STRAND,PROBE_COUNT,MANUFACTURER_PSR_ID,MICROARRAY_ID,NAME) tablespace CABIO_FUT;
alter table EXON_REPORTER enable constraint SYS_C0021092 using index SYS_C0021092_idx;
create unique index EXON_REPORTER_PK_idx on EXON_REPORTER
(ID) tablespace CABIO_FUT;
alter table EXON_REPORTER enable constraint EXON_REPORTER_PK using index EXON_REPORTER_PK_idx;

alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C0021092;
alter table EXON_REPORTER enable constraint SYS_C004422;
alter table EXON_REPORTER enable constraint SYS_C004423;
alter table EXON_REPORTER enable constraint SYS_C004424;
alter table EXON_REPORTER enable constraint SYS_C004425;
alter table EXON_REPORTER enable constraint SYS_C004426;
alter table EXON_REPORTER enable constraint SYS_C004427;
alter table EXON_REPORTER enable constraint SYS_C004428;
alter table EXON_REPORTER enable constraint SYS_C004429;
alter table EXON_REPORTER enable constraint EXON_REPORTER_PK;

alter table EXON_REPORTER enable primary key;

--EXIT;
