/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTION_XREF_lwr on ZSTG_PID_INTERACTIONCONDITION(lower(XREF)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTION_CONDITIONN_lwr on ZSTG_PID_INTERACTIONCONDITION(lower(CONDITIONNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
