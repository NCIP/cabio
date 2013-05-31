/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_ENTITY_SEQUENCE disable constraint SYS_C0016476;
alter table PID_ENTITY_SEQUENCE disable constraint SYS_C0016477;

alter table PID_ENTITY_SEQUENCE disable primary key;

--EXIT;
