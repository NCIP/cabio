/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CANCER_GENE__ROLE_ID_lwr on CANCER_GENE_INDEX_ASSOCIATION(lower(ROLE_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP;

--EXIT;
