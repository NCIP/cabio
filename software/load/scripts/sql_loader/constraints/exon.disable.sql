/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EXON disable constraint SYS_C0021091;
alter table EXON disable constraint SYS_C004416;
alter table EXON disable constraint SYS_C004417;
alter table EXON disable constraint SYS_C004418;
alter table EXON disable constraint SYS_C004419;
alter table EXON disable constraint XONBIGID;

alter table EXON disable primary key;

--EXIT;
