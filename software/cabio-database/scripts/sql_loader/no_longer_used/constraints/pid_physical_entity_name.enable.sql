/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016512_idx on PID_PHYSICAL_ENTITY_NAME
(ENTITY_NAME_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_PHYSICAL_ENTITY_NAME enable constraint SYS_C0016512 using index SYS_C0016512_idx;

alter table PID_PHYSICAL_ENTITY_NAME enable constraint SYS_C0016497;
alter table PID_PHYSICAL_ENTITY_NAME enable constraint SYS_C0016498;
alter table PID_PHYSICAL_ENTITY_NAME enable constraint SYS_C0016512;
alter table PID_PHYSICAL_ENTITY_NAME enable constraint SYS_C0016512;

alter table PID_PHYSICAL_ENTITY_NAME enable primary key;

--EXIT;
