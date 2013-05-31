/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_RELTION_TYPE_lwr on GENE_RELATIVE_LOCATION(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_RELTION_PROBE_SET__lwr on GENE_RELATIVE_LOCATION(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_RELTION_DISTANCE_lwr on GENE_RELATIVE_LOCATION(lower(DISTANCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_RELTION_ORIENTATIO_lwr on GENE_RELATIVE_LOCATION(lower(ORIENTATION)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
