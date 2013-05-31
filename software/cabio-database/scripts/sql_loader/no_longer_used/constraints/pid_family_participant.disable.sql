/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_FAMILY_PARTICIPANT disable constraint SYS_C0016478;
alter table PID_FAMILY_PARTICIPANT disable constraint SYS_C0016479;

alter table PID_FAMILY_PARTICIPANT disable primary key;

--EXIT;
