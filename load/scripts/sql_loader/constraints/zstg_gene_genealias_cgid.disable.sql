/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE_GENEALIAS_CGID disable constraint SYS_C004472;
alter table ZSTG_GENE_GENEALIAS_CGID disable constraint SYS_C004473;

alter table ZSTG_GENE_GENEALIAS_CGID disable primary key;

--EXIT;
