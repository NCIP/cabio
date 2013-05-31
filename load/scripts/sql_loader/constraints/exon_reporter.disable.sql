/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EXON_REPORTER disable constraint XONREPORTER;
alter table EXON_REPORTER disable constraint SYS_C0021092;
alter table EXON_REPORTER disable constraint SYS_C004422;
alter table EXON_REPORTER disable constraint SYS_C004423;
alter table EXON_REPORTER disable constraint SYS_C004424;
alter table EXON_REPORTER disable constraint SYS_C004425;
alter table EXON_REPORTER disable constraint SYS_C004426;
alter table EXON_REPORTER disable constraint SYS_C004427;
alter table EXON_REPORTER disable constraint SYS_C004428;
alter table EXON_REPORTER disable constraint SYS_C004429;

alter table EXON_REPORTER disable primary key;

--EXIT;
