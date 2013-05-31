/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENERIC_REPORTER disable constraint SYS_C0021099;
alter table GENERIC_REPORTER disable constraint SYS_C004452;
alter table GENERIC_REPORTER disable constraint SYS_C004453;
alter table GENERIC_REPORTER disable constraint GREP;

alter table GENERIC_REPORTER disable primary key;

--EXIT;
