/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CLONE_RELATIVE_LOCATION disable constraint SYS_C0021074;
alter table CLONE_RELATIVE_LOCATION disable constraint SYS_C004336;
alter table CLONE_RELATIVE_LOCATION disable constraint SYS_C004337;
alter table CLONE_RELATIVE_LOCATION disable constraint SYS_C004338;
alter table CLONE_RELATIVE_LOCATION disable constraint SYS_C004339;

alter table CLONE_RELATIVE_LOCATION disable primary key;

--EXIT;
