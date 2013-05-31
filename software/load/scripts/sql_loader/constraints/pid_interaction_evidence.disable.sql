/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_INTERACTION_EVIDENCE disable constraint SYS_C0016486;
alter table PID_INTERACTION_EVIDENCE disable constraint SYS_C0016487;

alter table PID_INTERACTION_EVIDENCE disable primary key;

--EXIT;
