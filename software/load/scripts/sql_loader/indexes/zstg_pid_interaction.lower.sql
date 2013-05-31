/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTION_TYPE_lwr on ZSTG_PID_INTERACTION(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_SOURCE_lwr on ZSTG_PID_INTERACTION(lower(SOURCE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
