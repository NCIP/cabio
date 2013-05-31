/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index LIBRARYRARY_IDS_LIB_TI_lwr on LIBRARY(lower(IDS_LIB_TISSUE_SAMPLE)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_IMAGE_LEGE_lwr on LIBRARY(lower(IMAGE_LEGEND)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_KEYWORD_lwr on LIBRARY(lower(KEYWORD)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_LAB_HOST_lwr on LIBRARY(lower(LAB_HOST)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_LIBRARY_NA_lwr on LIBRARY(lower(LIBRARY_NAME)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_R_SITE_1_lwr on LIBRARY(lower(R_SITE_1)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_R_SITE_2_lwr on LIBRARY(lower(R_SITE_2)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_DESCRIPTIO_lwr on LIBRARY(lower(DESCRIPTION)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_LIBRARY_TY_lwr on LIBRARY(lower(LIBRARY_TYPE)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_VECTOR_lwr on LIBRARY(lower(VECTOR)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_VECTOR_TYP_lwr on LIBRARY(lower(VECTOR_TYPE)) PARALLEL NOLOGGING tablespace CABIO;
create index LIBRARYRARY_PRODUCER_lwr on LIBRARY(lower(PRODUCER)) PARALLEL NOLOGGING tablespace CABIO;

--EXIT;
