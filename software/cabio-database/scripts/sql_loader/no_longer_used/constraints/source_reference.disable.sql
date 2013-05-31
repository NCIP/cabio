/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table SOURCE_REFERENCE disable constraint SYS_C004753;
alter table SOURCE_REFERENCE disable constraint SYS_C004754;
alter table SOURCE_REFERENCE disable constraint SYS_C004755;

alter table SOURCE_REFERENCE disable primary key;

--EXIT;
