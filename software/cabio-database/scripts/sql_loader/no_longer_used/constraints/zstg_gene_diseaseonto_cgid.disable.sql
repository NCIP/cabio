/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE_DISEASEONTO_CGID disable constraint SYS_C004940;
alter table ZSTG_GENE_DISEASEONTO_CGID disable constraint SYS_C004941;

alter table ZSTG_GENE_DISEASEONTO_CGID disable primary key;

--EXIT;
