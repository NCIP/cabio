/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table TRANSCRIPT_GENE disable constraint SYS_C004811;
alter table TRANSCRIPT_GENE disable constraint SYS_C004812;

alter table TRANSCRIPT_GENE disable primary key;

--EXIT;
