/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_SNP_REPORTER disable constraint SYS_C005239;
alter table ZSTG_SNP_REPORTER disable constraint SYS_C005240;
alter table ZSTG_SNP_REPORTER disable constraint SYS_C005241;

alter table ZSTG_SNP_REPORTER disable primary key;

--EXIT;
