/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_ENTREGENE_GENECHIP_A_lwr on AR_ENTREZ_GENE(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENTREGENE_ENTREZ_GEN_lwr on AR_ENTREZ_GENE(lower(ENTREZ_GENE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENTREGENE_PROBE_SET__lwr on AR_ENTREZ_GENE(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
