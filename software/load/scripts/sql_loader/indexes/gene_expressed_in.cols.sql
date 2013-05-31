/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_EXPD_IN_ORGAN_ID on GENE_EXPRESSED_IN(ORGAN_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_EXPD_IN_GENE_ID on GENE_EXPRESSED_IN(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
