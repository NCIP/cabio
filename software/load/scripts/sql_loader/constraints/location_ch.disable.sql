/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table LOCATION_CH disable constraint SYS_C0021116;
alter table LOCATION_CH disable constraint SYS_C004570;
alter table LOCATION_CH disable constraint SYS_C004571;
alter table LOCATION_CH disable constraint SYS_C004572;

alter table LOCATION_CH disable primary key;

--EXIT;
