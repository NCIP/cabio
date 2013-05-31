/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PID_PTM_PTM on ZSTG_PID_COMP_PARTCIPANT_PTM(PTM) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PID_PTM_ORDER_OF_C on ZSTG_PID_COMP_PARTCIPANT_PTM(ORDER_OF_COMPLEX) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PID_PTM_COMPLEX_ID on ZSTG_PID_COMP_PARTCIPANT_PTM(COMPLEX_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
