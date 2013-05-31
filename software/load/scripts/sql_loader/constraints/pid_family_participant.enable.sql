/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016504_idx on PID_FAMILY_PARTICIPANT
(PARTICIPANT_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_FAMILY_PARTICIPANT enable constraint SYS_C0016504 using index SYS_C0016504_idx;

alter table PID_FAMILY_PARTICIPANT enable constraint SYS_C0016478;
alter table PID_FAMILY_PARTICIPANT enable constraint SYS_C0016479;
alter table PID_FAMILY_PARTICIPANT enable constraint SYS_C0016504;
alter table PID_FAMILY_PARTICIPANT enable constraint SYS_C0016504;

alter table PID_FAMILY_PARTICIPANT enable primary key;

--EXIT;
