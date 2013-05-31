/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create  index NUCLEIC_ACID__ACCESSION_NUMBE on NUCLEIC_ACID_SEQUENCE (
ACCESSION_NUMBER ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__CLONE_ID on NUCLEIC_ACID_SEQUENCE (
CLONE_ID ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__DESCRIPTION on NUCLEIC_ACID_SEQUENCE (
DESCRIPTION ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__DISCRIMINATOR on NUCLEIC_ACID_SEQUENCE (
DISCRIMINATOR ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__ID on NUCLEIC_ACID_SEQUENCE (
ID ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__LENGTH on NUCLEIC_ACID_SEQUENCE (
LENGTH ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__SEQUENCE_TYPE on NUCLEIC_ACID_SEQUENCE (
SEQUENCE_TYPE ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  index NUCLEIC_ACID__VERSION on NUCLEIC_ACID_SEQUENCE (
VERSION ASC
 )
 tablespace CABIO_FUT parallel nologging;
create  UNIQUE index SYS_IL0000714610C00006$$ on NUCLEIC_ACID_SEQUENCE (
 tablespace CABIO_FUT parallel nologging;

--EXIT;
