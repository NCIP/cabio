/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index NUCLEIC_ENCE_DISCRIMINA on NUCLEIC_ACID_SEQUENCE(DISCRIMINATOR) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_DESCRIPTIO on NUCLEIC_ACID_SEQUENCE(DESCRIPTION) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_LENGTH on NUCLEIC_ACID_SEQUENCE(LENGTH) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_CLONE_ID on NUCLEIC_ACID_SEQUENCE(CLONE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_SEQUENCE_T on NUCLEIC_ACID_SEQUENCE(SEQUENCE_TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_VERSION on NUCLEIC_ACID_SEQUENCE(VERSION) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_ACCESSION_ on NUCLEIC_ACID_SEQUENCE(ACCESSION_NUMBER) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NUCLEIC_ENCE_ID on NUCLEIC_ACID_SEQUENCE(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
