/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table RELATIVE_LOCATION disable constraint SYS_C004713;
alter table RELATIVE_LOCATION disable constraint SYS_C004714;
alter table RELATIVE_LOCATION disable constraint SYS_C004715;
alter table RELATIVE_LOCATION disable constraint RCHBIGID;

alter table RELATIVE_LOCATION disable primary key;

--EXIT;
