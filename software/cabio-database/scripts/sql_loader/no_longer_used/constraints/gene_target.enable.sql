/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index GT_PK_idx on GENE_TARGET
(GENE_ID,TARGET_ID) tablespace CABIO_FUT;
alter table GENE_TARGET enable constraint GT_PK using index GT_PK_idx;

alter table GENE_TARGET enable constraint SYS_C004497;
alter table GENE_TARGET enable constraint SYS_C004498;
alter table GENE_TARGET enable constraint GT_PK;
alter table GENE_TARGET enable constraint GT_PK;

alter table GENE_TARGET enable primary key;

--EXIT;
