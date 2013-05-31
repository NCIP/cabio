/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PATENTS_INTERACTIO_lwr on ZSTG_PATHWAYCOMPONENTS(lower(INTERACTION_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATENTS_SOURCE_ID_lwr on ZSTG_PATHWAYCOMPONENTS(lower(SOURCE_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATENTS_PATHWAY_ID_lwr on ZSTG_PATHWAYCOMPONENTS(lower(PATHWAY_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
