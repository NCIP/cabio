/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_PHYSICAL_ENTITY disable constraint SYS_C0021157;
alter table PID_PHYSICAL_ENTITY disable constraint SYS_C0016492;
alter table PID_PHYSICAL_ENTITY disable constraint SYS_C0016493;
alter table PID_PHYSICAL_ENTITY disable constraint SYS_C0016494;

alter table PID_PHYSICAL_ENTITY disable primary key;

--EXIT;
