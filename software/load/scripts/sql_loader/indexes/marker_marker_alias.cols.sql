/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index MARKER_MLIAS_MARKER_ALI on MARKER_MARKER_ALIAS(MARKER_ALIAS_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKER_MLIAS_MARKER_ID on MARKER_MARKER_ALIAS(MARKER_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
