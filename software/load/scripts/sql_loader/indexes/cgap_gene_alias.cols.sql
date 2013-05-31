/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CGAP_GENLIAS_ALIAS on CGAP_GENE_ALIAS(ALIAS) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CGAP_GENLIAS_GENE_ID on CGAP_GENE_ALIAS(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
