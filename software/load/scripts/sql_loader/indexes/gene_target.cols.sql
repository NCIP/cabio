/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_TARRGET_LOCUS_ID on GENE_TARGET(LOCUS_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_TARRGET_GENE_ID on GENE_TARGET(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_TARRGET_TARGET_ID on GENE_TARGET(TARGET_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
