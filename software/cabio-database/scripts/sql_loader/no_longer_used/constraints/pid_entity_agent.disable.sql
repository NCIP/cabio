/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_ENTITY_AGENT disable constraint SYS_C0016469;
alter table PID_ENTITY_AGENT disable constraint SYS_C0016470;

alter table PID_ENTITY_AGENT disable primary key;

--EXIT;
