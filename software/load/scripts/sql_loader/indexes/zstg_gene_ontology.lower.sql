/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENLOGY_LOCUS_ID_lwr on ZSTG_GENE_ONTOLOGY(lower(LOCUS_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
