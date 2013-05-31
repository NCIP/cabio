/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_INTERACTION_EC disable constraint SYS_C0016484;
alter table PID_INTERACTION_EC disable constraint SYS_C0016485;

alter table PID_INTERACTION_EC disable primary key;

--EXIT;
