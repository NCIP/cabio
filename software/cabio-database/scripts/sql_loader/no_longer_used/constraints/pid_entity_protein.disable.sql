/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_ENTITY_PROTEIN disable constraint SYS_C0016474;
alter table PID_ENTITY_PROTEIN disable constraint SYS_C0016475;
alter table PID_ENTITY_PROTEIN disable constraint SYS_C0021151;

alter table PID_ENTITY_PROTEIN disable primary key;

--EXIT;
