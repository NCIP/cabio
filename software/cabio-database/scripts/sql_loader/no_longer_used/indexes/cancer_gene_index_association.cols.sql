/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CANCER_GENE_I_GENE_ID on CANCER_GENE_INDEX_ASSOCIATION(GENE_ID) tablespace CABIO_MAP;
create index CANCER_GENE_I_ROLE_ID on CANCER_GENE_INDEX_ASSOCIATION(ROLE_ID) tablespace CABIO_MAP;
create index CANCER_GENE_I_ID on CANCER_GENE_INDEX_ASSOCIATION(ID) tablespace CABIO_MAP;
create index CANCER_GENE_I_AGENT_ID on CANCER_GENE_INDEX_ASSOCIATION(AGENT_ID) tablespace CABIO_MAP;
create index CANCER_GENE_I_HISTOLOGYCODE_I on CANCER_GENE_INDEX_ASSOCIATION(HISTOLOGYCODE_ID) tablespace CABIO_MAP;
create index CANCER_GENE_I_EVIDENCE_ID on CANCER_GENE_INDEX_ASSOCIATION(EVIDENCE_ID) tablespace CABIO_MAP;

--EXIT;
