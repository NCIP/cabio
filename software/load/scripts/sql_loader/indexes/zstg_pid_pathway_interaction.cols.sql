/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTION_INTERACTIO on ZSTG_PID_PATHWAY_INTERACTION(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_PATHWAY_ID on ZSTG_PID_PATHWAY_INTERACTION(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
