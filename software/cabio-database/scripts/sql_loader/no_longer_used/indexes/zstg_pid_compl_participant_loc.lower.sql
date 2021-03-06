/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PID_LOC_XREF_lwr on ZSTG_PID_COMPL_PARTICIPANT_LOC(lower(XREF)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PID_LOC_LOCATION_lwr on ZSTG_PID_COMPL_PARTICIPANT_LOC(lower(LOCATION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PID_LOC_ORDER_OF_C_lwr on ZSTG_PID_COMPL_PARTICIPANT_LOC(lower(ORDER_OF_COMPLEX)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
