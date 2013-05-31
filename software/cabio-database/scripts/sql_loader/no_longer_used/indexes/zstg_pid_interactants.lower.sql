/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDANTS_ROLE_lwr on ZSTG_PID_INTERACTANTS(lower(ROLE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
