/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_POPENCY_ALLELE_B_lwr on ZSTG_POP_FREQUENCY(lower(ALLELE_B)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_ALLELE_A_lwr on ZSTG_POP_FREQUENCY(lower(ALLELE_A)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_ETHNICITY_lwr on ZSTG_POP_FREQUENCY(lower(ETHNICITY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_POPENCY_PROBE_SET__lwr on ZSTG_POP_FREQUENCY(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
