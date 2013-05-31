/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDNAME_NAME on ZSTG_PID_ENTITYNAME(NAME) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDNAME_NAMETYPE on ZSTG_PID_ENTITYNAME(NAMETYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDNAME_PHYSICALEN on ZSTG_PID_ENTITYNAME(PHYSICALENTITY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
