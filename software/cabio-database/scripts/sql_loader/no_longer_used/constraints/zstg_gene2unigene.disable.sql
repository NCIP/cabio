/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE2UNIGENE disable constraint SYS_C004929;
alter table ZSTG_GENE2UNIGENE disable constraint SYS_C004930;

alter table ZSTG_GENE2UNIGENE disable primary key;

--EXIT;
