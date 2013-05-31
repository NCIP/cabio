/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENE2GO_CATEGORY_lwr on ZSTG_GENE2GO(lower(CATEGORY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE2GO_PUBMED_lwr on ZSTG_GENE2GO(lower(PUBMED)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE2GO_GO_TERM_lwr on ZSTG_GENE2GO(lower(GO_TERM)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE2GO_QUALIFIER_lwr on ZSTG_GENE2GO(lower(QUALIFIER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE2GO_EVIDENCE_lwr on ZSTG_GENE2GO(lower(EVIDENCE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENE2GO_GO_ID_lwr on ZSTG_GENE2GO(lower(GO_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
