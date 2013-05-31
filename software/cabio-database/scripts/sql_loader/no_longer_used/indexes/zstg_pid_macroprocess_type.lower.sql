/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDTYPE_XREF_lwr on ZSTG_PID_MACROPROCESS_TYPE(lower(XREF)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDTYPE_MACROPROCE_lwr on ZSTG_PID_MACROPROCESS_TYPE(lower(MACROPROCESS_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
