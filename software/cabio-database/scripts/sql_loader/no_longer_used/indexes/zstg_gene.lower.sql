/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENGENE_END_CYTOBA_lwr on ZSTG_GENE(lower(END_CYTOBAND)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_START_CYTO_lwr on ZSTG_GENE(lower(START_CYTOBAND)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_IDENTIFIER_lwr on ZSTG_GENE(lower(IDENTIFIER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_CYTOBAND_lwr on ZSTG_GENE(lower(CYTOBAND)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_GENE_TITLE_lwr on ZSTG_GENE(lower(GENE_TITLE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_GENE_SYMBO_lwr on ZSTG_GENE(lower(GENE_SYMBOL)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
