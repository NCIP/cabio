/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTITY_TYPE on ZSTG_PID_PHYSICALENTITY(TYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTITY_PHYSICALEN on ZSTG_PID_PHYSICALENTITY(PHYSICALENTITY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
