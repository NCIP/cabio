/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TAXONAXON_STRAIN_OR__lwr on TAXON(lower(STRAIN_OR_ETHNICITY)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TAXONAXON_COMMON_NAM_lwr on TAXON(lower(COMMON_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TAXONAXON_ABBREVIATI_lwr on TAXON(lower(ABBREVIATION)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TAXONAXON_SCIENTIFIC_lwr on TAXON(lower(SCIENTIFIC_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
