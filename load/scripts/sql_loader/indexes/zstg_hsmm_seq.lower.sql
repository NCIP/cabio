/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_HSM_SEQ_SEQUENCE_T_lwr on ZSTG_HSMM_SEQ(lower(SEQUENCE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_HSM_SEQ_VERSION_lwr on ZSTG_HSMM_SEQ(lower(VERSION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_HSM_SEQ_ACCESSION__lwr on ZSTG_HSMM_SEQ(lower(ACCESSION_NUMBER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
