/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE_ONTOLOGY disable constraint SYS_C004958;
alter table ZSTG_GENE_ONTOLOGY disable constraint SYS_C004959;
alter table ZSTG_GENE_ONTOLOGY disable constraint SYS_C004960;

alter table ZSTG_GENE_ONTOLOGY disable primary key;

--EXIT;
