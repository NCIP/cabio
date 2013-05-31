/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_CGHIONS_ACCESSION_lwr on ZSTG_CGH_ACCESSIONS(lower(ACCESSION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_CGHIONS_SOURCE_lwr on ZSTG_CGH_ACCESSIONS(lower(SOURCE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_CGHIONS_IND_lwr on ZSTG_CGH_ACCESSIONS(lower(IND)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_CGHIONS_PROBE_SET__lwr on ZSTG_CGH_ACCESSIONS(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
