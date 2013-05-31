/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_MAIN_TYPE on PROTEIN_DOMAIN(TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_MAIN_DESCRIPTIO on PROTEIN_DOMAIN(DESCRIPTION) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_MAIN_ACCESSION_ on PROTEIN_DOMAIN(ACCESSION_NUMBER) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_MAIN_ID on PROTEIN_DOMAIN(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
