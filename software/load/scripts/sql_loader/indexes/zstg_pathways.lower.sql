/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PATWAYS_SOURCE_ID_lwr on ZSTG_PATHWAYS(lower(SOURCE_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATWAYS_SHORTNAME_lwr on ZSTG_PATHWAYS(lower(SHORTNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATWAYS_LONGNAME_lwr on ZSTG_PATHWAYS(lower(LONGNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATWAYS_SUBNET_lwr on ZSTG_PATHWAYS(lower(SUBNET)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATWAYS_PATHWAY_ID_lwr on ZSTG_PATHWAYS(lower(PATHWAY_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PATWAYS_ORGANISM_lwr on ZSTG_PATHWAYS(lower(ORGANISM)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
