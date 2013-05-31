/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_INTERACTION disable constraint SYS_C0021154;
alter table PID_INTERACTION disable constraint SYS_C0016480;
alter table PID_INTERACTION disable constraint SYS_C0016481;
alter table PID_INTERACTION disable constraint SYS_C0016482;
alter table PID_INTERACTION disable constraint SYS_C0016483;

alter table PID_INTERACTION disable primary key;

--EXIT;
