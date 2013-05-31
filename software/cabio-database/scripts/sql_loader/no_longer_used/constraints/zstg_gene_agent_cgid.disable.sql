/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_GENE_AGENT_CGID disable constraint SYS_C004936;
alter table ZSTG_GENE_AGENT_CGID disable constraint SYS_C004937;

alter table ZSTG_GENE_AGENT_CGID disable primary key;

--EXIT;
