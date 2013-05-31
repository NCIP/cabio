/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index MARKER_ALIAS_NAME on MARKER_ALIAS(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index MARKER_ALIAS_ID on MARKER_ALIAS(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
