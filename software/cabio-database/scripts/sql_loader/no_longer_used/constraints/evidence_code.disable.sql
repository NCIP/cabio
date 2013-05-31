/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EVIDENCE_CODE disable constraint SYS_C0021090;
alter table EVIDENCE_CODE disable constraint SYS_C004413;
alter table EVIDENCE_CODE disable constraint SYS_C004414;

alter table EVIDENCE_CODE disable primary key;

--EXIT;
