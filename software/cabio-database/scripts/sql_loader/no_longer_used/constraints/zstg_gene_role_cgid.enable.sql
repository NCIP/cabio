/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0020848_idx on ZSTG_GENE_ROLE_CGID
(ROLE_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_ROLE_CGID enable constraint SYS_C0020848 using index SYS_C0020848_idx;

alter table ZSTG_GENE_ROLE_CGID enable constraint SYS_C0020848;
alter table ZSTG_GENE_ROLE_CGID enable constraint SYS_C0020848;

alter table ZSTG_GENE_ROLE_CGID enable primary key;

--EXIT;
