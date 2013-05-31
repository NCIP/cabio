/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_KEYWORDS_GENE_ID on GENE_KEYWORDS(GENE_ID) tablespace CABIO;
create index GENE_KEYWORDS_CLUSTER_NUMBER on GENE_KEYWORDS(CLUSTER_NUMBER) tablespace CABIO;
create index GENE_KEYWORDS_LIBRARY_ID on GENE_KEYWORDS(LIBRARY_ID) tablespace CABIO;
create index GENE_KEYWORDS_KEYWORD on GENE_KEYWORDS(KEYWORD) tablespace CABIO;
create index GENE_KEYWORDS_HISTOLOGY_CODE on GENE_KEYWORDS(HISTOLOGY_CODE) tablespace CABIO;
create index GENE_KEYWORDS_TISSUE_CODE on GENE_KEYWORDS(TISSUE_CODE) tablespace CABIO;
create index GENE_KEYWORDS_CONTEXT_CODE on GENE_KEYWORDS(CONTEXT_CODE) tablespace CABIO;

--EXIT;
