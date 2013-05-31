/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDNAME_NAME_lwr on ZSTG_PID_ENTITYNAME(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDNAME_NAMETYPE_lwr on ZSTG_PID_ENTITYNAME(lower(NAMETYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
