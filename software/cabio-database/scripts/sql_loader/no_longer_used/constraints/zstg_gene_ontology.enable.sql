/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0020847_idx on ZSTG_GENE_ONTOLOGY
(LOCUS_ID,ORGANISM,GO_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C0020847 using index SYS_C0020847_idx;

alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C0020847;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C0020847;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C0020847;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C004958;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C004959;
alter table ZSTG_GENE_ONTOLOGY enable constraint SYS_C004960;

alter table ZSTG_GENE_ONTOLOGY enable primary key;

--EXIT;
