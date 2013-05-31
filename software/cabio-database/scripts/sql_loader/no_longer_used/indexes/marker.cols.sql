/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index MARKERRKER_ACCNO on MARKER(ACCNO) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKERRKER_TAXON_ID on MARKER(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKERRKER_TYPE on MARKER(TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKERRKER_MARKER_ID on MARKER(MARKER_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKERRKER_NAME on MARKER(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKERRKER_ID on MARKER(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
