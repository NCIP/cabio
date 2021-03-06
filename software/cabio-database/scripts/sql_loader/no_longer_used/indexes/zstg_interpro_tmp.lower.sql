/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_INT_TMP_GENECHIP_A_lwr on ZSTG_INTERPRO_TMP(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INT_TMP_DESCRIPTIO_lwr on ZSTG_INTERPRO_TMP(lower(DESCRIPTION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INT_TMP_ACCESSION__lwr on ZSTG_INTERPRO_TMP(lower(ACCESSION_NUMBER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INT_TMP_PROBE_SET__lwr on ZSTG_INTERPRO_TMP(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
