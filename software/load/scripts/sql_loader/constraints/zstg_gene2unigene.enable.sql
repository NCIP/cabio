/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0020835_idx on ZSTG_GENE2UNIGENE
(UNIGENE_CLUSTER,GENEID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE2UNIGENE enable constraint SYS_C0020835 using index SYS_C0020835_idx;

alter table ZSTG_GENE2UNIGENE enable constraint SYS_C004929;
alter table ZSTG_GENE2UNIGENE enable constraint SYS_C004930;
alter table ZSTG_GENE2UNIGENE enable constraint SYS_C0020835;
alter table ZSTG_GENE2UNIGENE enable constraint SYS_C0020835;

alter table ZSTG_GENE2UNIGENE enable primary key;

--EXIT;
