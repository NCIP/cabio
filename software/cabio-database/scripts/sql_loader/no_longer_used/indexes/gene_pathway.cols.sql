/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_PATHWAY_PATHWAY_ID on GENE_PATHWAY(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_PATHWAY_BC_ID on GENE_PATHWAY(BC_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
