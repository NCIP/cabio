/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index ZPEPK_idx on ZSTG_PROTEIN_EMBL
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_PROTEIN_EMBL enable constraint ZPEPK using index ZPEPK_idx;

alter table ZSTG_PROTEIN_EMBL enable constraint SYS_C005069;
alter table ZSTG_PROTEIN_EMBL enable constraint SYS_C005070;
alter table ZSTG_PROTEIN_EMBL enable constraint SYS_C005071;
alter table ZSTG_PROTEIN_EMBL enable constraint ZPEPK;

alter table ZSTG_PROTEIN_EMBL enable primary key;

--EXIT;
