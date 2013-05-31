/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_EXORTER_STRAND_lwr on ZSTG_EXON_REPORTER(lower(STRAND)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXORTER_PROBE_COUN_lwr on ZSTG_EXON_REPORTER(lower(PROBE_COUNT)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXORTER_MANUFACTUR_lwr on ZSTG_EXON_REPORTER(lower(MANUFACTURER_PSR_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXORTER_NAME_lwr on ZSTG_EXON_REPORTER(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
