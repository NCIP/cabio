/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_NUCENCE_GENE_SEQUE on GENE_NUCLEIC_ACID_SEQUENCE(GENE_SEQUENCE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_NUCENCE_GENE_ID on GENE_NUCLEIC_ACID_SEQUENCE(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
