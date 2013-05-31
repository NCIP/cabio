/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_ONTOLLOGY_MM_GENES on GO_ONTOLOGY(MM_GENES) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_ONTOLLOGY_HS_GENES on GO_ONTOLOGY(HS_GENES) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_ONTOLLOGY_GO_NAME on GO_ONTOLOGY(GO_NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_ONTOLLOGY_GO_ID on GO_ONTOLOGY(GO_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_ONTOLLOGY_TAXON_ID on GO_ONTOLOGY(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
