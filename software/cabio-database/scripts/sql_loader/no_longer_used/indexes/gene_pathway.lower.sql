/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_PATHWAY_BC_ID_lwr on GENE_PATHWAY(lower(BC_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
