/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index MARKER_LOKUP_TAXON_ID on MARKER_LOOKUP(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKER_LOKUP_ID on MARKER_LOOKUP(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKER_LOKUP_NAME on MARKER_LOOKUP(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
