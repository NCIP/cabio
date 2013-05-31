/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ARRAY_REPORTER disable constraint SYS_C0021036;
alter table ARRAY_REPORTER disable constraint SYS_C004158;
alter table ARRAY_REPORTER disable constraint SYS_C004159;
alter table ARRAY_REPORTER disable constraint SYS_C004160;

alter table ARRAY_REPORTER disable primary key;

--EXIT;
