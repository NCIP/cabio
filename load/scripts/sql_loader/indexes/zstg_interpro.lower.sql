/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_INTRPRO_GENECHIP_A_lwr on ZSTG_INTERPRO(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INTRPRO_DESCRIPTIO_lwr on ZSTG_INTERPRO(lower(DESCRIPTION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INTRPRO_ACCESSION__lwr on ZSTG_INTERPRO(lower(ACCESSION_NUMBER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_INTRPRO_PROBE_SET__lwr on ZSTG_INTERPRO(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
