/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_ALIGNENTS_GENECHIP_A_lwr on AR_ALIGNMENTS(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ALIGNENTS_ASSEMBLY_lwr on AR_ALIGNMENTS(lower(ASSEMBLY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ALIGNENTS_TRIM_CHR_lwr on AR_ALIGNMENTS(lower(TRIM_CHR)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ALIGNENTS_CHROMOSOME_lwr on AR_ALIGNMENTS(lower(CHROMOSOME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ALIGNENTS_PROBE_SET__lwr on AR_ALIGNMENTS(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
