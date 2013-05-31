/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_GENESENES_GO_ID on GO_GENES(GO_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_GENESENES_TAXON_ID on GO_GENES(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_GENESENES_GENE_ID on GO_GENES(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
