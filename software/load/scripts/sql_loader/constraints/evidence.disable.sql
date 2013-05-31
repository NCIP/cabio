/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EVIDENCE disable constraint SYS_C004408;
alter table EVIDENCE disable constraint SYS_C004409;
alter table EVIDENCE disable constraint SYS_C004410;

alter table EVIDENCE disable primary key;

--EXIT;
