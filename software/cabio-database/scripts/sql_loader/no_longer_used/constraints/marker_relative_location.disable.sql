/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C0016540;
alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C0016541;
alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C004595;
alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C004596;
alter table MARKER_RELATIVE_LOCATION disable constraint SYS_C0016539;

alter table MARKER_RELATIVE_LOCATION disable primary key;

--EXIT;
