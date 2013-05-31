/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016503_idx on PID_ENTITY_SEQUENCE
(NUCLEIC_ACID_SEQUENCE_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_ENTITY_SEQUENCE enable constraint SYS_C0016503 using index SYS_C0016503_idx;

alter table PID_ENTITY_SEQUENCE enable constraint SYS_C0016476;
alter table PID_ENTITY_SEQUENCE enable constraint SYS_C0016477;
alter table PID_ENTITY_SEQUENCE enable constraint SYS_C0016503;
alter table PID_ENTITY_SEQUENCE enable constraint SYS_C0016503;

alter table PID_ENTITY_SEQUENCE enable primary key;

--EXIT;
