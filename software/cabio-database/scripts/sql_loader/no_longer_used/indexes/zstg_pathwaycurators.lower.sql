/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PATTORS_CURATOR_NA_lwr on ZSTG_PATHWAYCURATORS(lower(CURATOR_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATTORS_SOURCE_ID_lwr on ZSTG_PATHWAYCURATORS(lower(SOURCE_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATTORS_PATHWAY_ID_lwr on ZSTG_PATHWAYCURATORS(lower(PATHWAY_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
