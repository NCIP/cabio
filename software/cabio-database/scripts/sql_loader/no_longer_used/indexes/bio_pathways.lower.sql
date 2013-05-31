/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index BIO_PATHWAYS_PATHWAY_DI_lwr on BIO_PATHWAYS(lower(PATHWAY_DIAGRAM)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index BIO_PATHWAYS_PATHWAY_DI_lwr on BIO_PATHWAYS(lower(PATHWAY_DISPLAY)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index BIO_PATHWAYS_PATHWAY_NA_lwr on BIO_PATHWAYS(lower(PATHWAY_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
