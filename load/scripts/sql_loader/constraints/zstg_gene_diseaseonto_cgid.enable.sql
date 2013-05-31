/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0020840_idx on ZSTG_GENE_DISEASEONTO_CGID
(DISEASE_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_DISEASEONTO_CGID enable constraint SYS_C0020840 using index SYS_C0020840_idx;

alter table ZSTG_GENE_DISEASEONTO_CGID enable constraint SYS_C004940;
alter table ZSTG_GENE_DISEASEONTO_CGID enable constraint SYS_C004941;
alter table ZSTG_GENE_DISEASEONTO_CGID enable constraint SYS_C0020840;
alter table ZSTG_GENE_DISEASEONTO_CGID enable constraint SYS_C0020840;

alter table ZSTG_GENE_DISEASEONTO_CGID enable primary key;

--EXIT;
