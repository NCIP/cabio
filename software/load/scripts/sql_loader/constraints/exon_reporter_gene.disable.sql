/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EXON_REPORTER_GENE disable constraint SYS_C004432;
alter table EXON_REPORTER_GENE disable constraint SYS_C004433;

alter table EXON_REPORTER_GENE disable primary key;

--EXIT;
