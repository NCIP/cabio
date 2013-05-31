/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ARRAY_REPORTER_CH disable constraint SYS_C0021037;
alter table ARRAY_REPORTER_CH disable constraint SYS_C004162;
alter table ARRAY_REPORTER_CH disable constraint SYS_C004163;
alter table ARRAY_REPORTER_CH disable constraint SYS_C004164;
alter table ARRAY_REPORTER_CH disable constraint SYS_C004165;
alter table ARRAY_REPORTER_CH disable constraint ARREPBIGID;

alter table ARRAY_REPORTER_CH disable primary key;

--EXIT;
