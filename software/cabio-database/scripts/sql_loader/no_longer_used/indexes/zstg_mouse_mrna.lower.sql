/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_MOUMRNA_CHROMOSOME_lwr on ZSTG_MOUSE_MRNA(lower(CHROMOSOME_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MOUMRNA_CHROMOSOME_lwr on ZSTG_MOUSE_MRNA(lower(CHROMOSOME_NO)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MOUMRNA_TNAME_lwr on ZSTG_MOUSE_MRNA(lower(TNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_MOUMRNA_QNAME_lwr on ZSTG_MOUSE_MRNA(lower(QNAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
