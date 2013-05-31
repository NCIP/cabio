/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENIERS_IDENTIFIER on ZSTG_GENE_IDENTIFIERS(IDENTIFIER) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENIERS_DATA_SOURC on ZSTG_GENE_IDENTIFIERS(DATA_SOURCE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENIERS_GENE_ID on ZSTG_GENE_IDENTIFIERS(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
