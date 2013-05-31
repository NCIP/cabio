/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_MARLIAS_MARKER_ID_lwr on ZSTG_MARKER_ALIAS(lower(MARKER_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MARLIAS_NAME_lwr on ZSTG_MARKER_ALIAS(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
