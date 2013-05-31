/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENE_DIS_GENE_ID on ZSTG_GENE_DISEASEONTOLOGY_CGID(GENE_ID) tablespace CABIO_MAP_FUT;
create index ZSTG_GENE_DIS_DISEASEONTOLOGY on ZSTG_GENE_DISEASEONTOLOGY_CGID(DISEASEONTOLOGY_ID) tablespace CABIO_MAP_FUT;

--EXIT;
