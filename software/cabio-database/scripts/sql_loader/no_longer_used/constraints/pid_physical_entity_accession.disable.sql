/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_PHYSICAL_ENTITY_ACCESSION disable constraint SYS_C0016495;
alter table PID_PHYSICAL_ENTITY_ACCESSION disable constraint SYS_C0016496;

alter table PID_PHYSICAL_ENTITY_ACCESSION disable primary key;

--EXIT;
