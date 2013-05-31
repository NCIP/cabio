/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENE_DI_GENE_ID_lwr on ZSTG_GENE_DISEASEONTOLOGY_CGID(lower(GENE_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE_DI_DISEASEONTOL_lwr on ZSTG_GENE_DISEASEONTOLOGY_CGID(lower(DISEASEONTOLOGY_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
