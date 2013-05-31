/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EXON_REPRTER_STRAND_lwr on EXON_REPORTER(lower(STRAND)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXON_REPRTER_PROBE_COUN_lwr on EXON_REPORTER(lower(PROBE_COUNT)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXON_REPRTER_MANUFACTUR_lwr on EXON_REPORTER(lower(MANUFACTURER_PSR_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXON_REPRTER_NAME_lwr on EXON_REPORTER(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
