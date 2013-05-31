/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_FUNTION_DISCRIMINA_lwr on GENE_FUNCTION_ASSOCIATION(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_FUNTION_ROLE_ID_lwr on GENE_FUNCTION_ASSOCIATION(lower(ROLE_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
