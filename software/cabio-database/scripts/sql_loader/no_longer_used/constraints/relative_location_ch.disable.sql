/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table RELATIVE_LOCATION_CH disable constraint SYS_C0021179;
alter table RELATIVE_LOCATION_CH disable constraint SYS_C004718;
alter table RELATIVE_LOCATION_CH disable constraint SYS_C004719;
alter table RELATIVE_LOCATION_CH disable constraint SYS_C004720;
alter table RELATIVE_LOCATION_CH disable constraint SYS_C004721;
alter table RELATIVE_LOCATION_CH disable constraint SYS_C004722;

alter table RELATIVE_LOCATION_CH disable primary key;

--EXIT;
