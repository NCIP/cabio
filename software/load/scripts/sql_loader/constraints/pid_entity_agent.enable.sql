/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016500_idx on PID_ENTITY_AGENT
(AGENT_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_ENTITY_AGENT enable constraint SYS_C0016500 using index SYS_C0016500_idx;

alter table PID_ENTITY_AGENT enable constraint SYS_C0016469;
alter table PID_ENTITY_AGENT enable constraint SYS_C0016470;
alter table PID_ENTITY_AGENT enable constraint SYS_C0016500;
alter table PID_ENTITY_AGENT enable constraint SYS_C0016500;

alter table PID_ENTITY_AGENT enable primary key;

--EXIT;
