/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_MARLIAS_MARKER_ID on ZSTG_MARKER_ALIAS(MARKER_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MARLIAS_NAME on ZSTG_MARKER_ALIAS(NAME) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MARLIAS_ID on ZSTG_MARKER_ALIAS(ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
