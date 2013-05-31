/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016507_idx on PID_INTERACTION_EVIDENCE
(EVIDENCE_ID,INTERACTION_ID) tablespace CABIO_FUT;
alter table PID_INTERACTION_EVIDENCE enable constraint SYS_C0016507 using index SYS_C0016507_idx;

alter table PID_INTERACTION_EVIDENCE enable constraint SYS_C0016486;
alter table PID_INTERACTION_EVIDENCE enable constraint SYS_C0016487;
alter table PID_INTERACTION_EVIDENCE enable constraint SYS_C0016507;
alter table PID_INTERACTION_EVIDENCE enable constraint SYS_C0016507;

alter table PID_INTERACTION_EVIDENCE enable primary key;

--EXIT;
