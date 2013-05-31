/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_RNA_PAFFY_ANNOTATION_lwr on AR_RNA_PROBESETS_AFFY(lower(ANNOTATION_DATA)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_RNA_PAFFY_SPECIES_SC_lwr on AR_RNA_PROBESETS_AFFY(lower(SPECIES_SCIENTIFIC_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_RNA_PAFFY_GENECHIP_A_lwr on AR_RNA_PROBESETS_AFFY(lower(GENECHIP_ARRAY_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_RNA_PAFFY_PROBE_SET__lwr on AR_RNA_PROBESETS_AFFY(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
