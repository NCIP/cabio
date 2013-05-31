/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PHYSICAL_LOCATION disable constraint SYS_C004636;
alter table PHYSICAL_LOCATION disable constraint SYS_C004633;
alter table PHYSICAL_LOCATION disable constraint SYS_C004634;
alter table PHYSICAL_LOCATION disable constraint SYS_C004635;

alter table PHYSICAL_LOCATION disable primary key;

--EXIT;
