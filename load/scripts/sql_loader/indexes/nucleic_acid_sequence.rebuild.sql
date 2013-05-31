/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter index NUCLEIC_ACID_DISCRIMINATO_LWR rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID_SEQUENCE_TYP_LWR rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID_VERSION_LWR rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__ACCESSION_NUMBE rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__CLONE_ID rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__DESCRIPTION rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__DISCRIMINATOR rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__ID rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__LENGTH rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__SEQUENCE_TYPE rebuild tablespace CABIO_FUT;
alter index NUCLEIC_ACID__VERSION rebuild tablespace CABIO_FUT;
alter index SYS_IL0000714610C00006$$ rebuild tablespace CABIO_FUT;

--EXIT;
