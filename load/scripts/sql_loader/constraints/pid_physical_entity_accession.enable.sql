/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016511_idx on PID_PHYSICAL_ENTITY_ACCESSION
(ENTITY_ACCESSION_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_PHYSICAL_ENTITY_ACCESSION enable constraint SYS_C0016511 using index SYS_C0016511_idx;

alter table PID_PHYSICAL_ENTITY_ACCESSION enable constraint SYS_C0016495;
alter table PID_PHYSICAL_ENTITY_ACCESSION enable constraint SYS_C0016496;
alter table PID_PHYSICAL_ENTITY_ACCESSION enable constraint SYS_C0016511;
alter table PID_PHYSICAL_ENTITY_ACCESSION enable constraint SYS_C0016511;

alter table PID_PHYSICAL_ENTITY_ACCESSION enable primary key;

--EXIT;
