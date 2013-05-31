/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table MARKER disable constraint MARKERBIGID;
alter table MARKER disable constraint SYS_C0021119;
alter table MARKER disable constraint SYS_C004577;
alter table MARKER disable constraint SYS_C004578;
alter table MARKER disable constraint SYS_C004579;
alter table MARKER disable constraint SYS_C004580;

alter table MARKER disable primary key;

--EXIT;
