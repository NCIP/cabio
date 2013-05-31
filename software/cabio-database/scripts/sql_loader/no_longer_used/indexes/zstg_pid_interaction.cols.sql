/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTION_TYPE on ZSTG_PID_INTERACTION(TYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_SOURCE on ZSTG_PID_INTERACTION(SOURCE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_INTERACTIO on ZSTG_PID_INTERACTION(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
