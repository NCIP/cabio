/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_GENLIAS_GENE_ALIAS on GENE_GENEALIAS(GENE_ALIAS_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_GENLIAS_ALIAS_ID on GENE_GENEALIAS(ALIAS_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_GENLIAS_GENE_ID on GENE_GENEALIAS(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
