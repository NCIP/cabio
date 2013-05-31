/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_PROTEIN_EMBL disable constraint SYS_C005069;
alter table ZSTG_PROTEIN_EMBL disable constraint SYS_C005070;
alter table ZSTG_PROTEIN_EMBL disable constraint SYS_C005071;

alter table ZSTG_PROTEIN_EMBL disable primary key;

--EXIT;
