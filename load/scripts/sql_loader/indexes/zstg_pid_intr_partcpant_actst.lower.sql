/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDCTST_XREF_lwr on ZSTG_PID_INTR_PARTCPANT_ACTST(lower(XREF)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDCTST_ACTIVITY_S_lwr on ZSTG_PID_INTR_PARTCPANT_ACTST(lower(ACTIVITY_STATE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
