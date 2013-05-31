/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENLOGY_LOCUS_ID on ZSTG_GENE_ONTOLOGY(LOCUS_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENLOGY_ORGANISM on ZSTG_GENE_ONTOLOGY(ORGANISM) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENLOGY_GO_ID on ZSTG_GENE_ONTOLOGY(GO_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
