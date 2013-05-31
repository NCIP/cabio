/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_PHYSICAL_ENTITY_NAME disable constraint SYS_C0016497;
alter table PID_PHYSICAL_ENTITY_NAME disable constraint SYS_C0016498;

alter table PID_PHYSICAL_ENTITY_NAME disable primary key;

--EXIT;
