/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_ORDS_PROTEIN_ID on PROTEIN_KEYWORDS(PROTEIN_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_ORDS_KEYWORD on PROTEIN_KEYWORDS(KEYWORD) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_ORDS_ID on PROTEIN_KEYWORDS(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
