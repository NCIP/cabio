/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_GENE_MBOL_GENECHIP_A on AR_GENE_SYMBOL(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GENE_MBOL_GENE_SYMBO on AR_GENE_SYMBOL(GENE_SYMBOL) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_GENE_MBOL_PROBE_SET_ on AR_GENE_SYMBOL(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
