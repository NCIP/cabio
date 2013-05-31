/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE_MARKERS disable constraint SYS_C004956;
alter table ZSTG_GENE_MARKERS disable constraint SYS_C004957;

alter table ZSTG_GENE_MARKERS disable primary key;

--EXIT;
