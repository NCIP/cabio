/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_ENTRE_TMP_GENECHIP_A on AR_ENTREZ_GENE_TMP(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENTRE_TMP_ENTREZ_GEN on AR_ENTREZ_GENE_TMP(ENTREZ_GENE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_ENTRE_TMP_PROBE_SET_ on AR_ENTREZ_GENE_TMP(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
