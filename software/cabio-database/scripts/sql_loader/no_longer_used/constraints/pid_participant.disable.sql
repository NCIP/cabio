/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_PARTICIPANT disable constraint SYS_C0016488;
alter table PID_PARTICIPANT disable constraint SYS_C0016489;

alter table PID_PARTICIPANT disable primary key;

--EXIT;
