/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PID_PATHWAY_INTERACTION disable constraint SYS_C0016490;
alter table PID_PATHWAY_INTERACTION disable constraint SYS_C0016491;

alter table PID_PATHWAY_INTERACTION disable primary key;

--EXIT;
