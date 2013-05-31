/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
create index biopath_idx on BIO_PATHWAYS(PATHWAY_DIAGRAM) tablespace &prod_tablspc;
create index biopath_idx_lwr on BIO_PATHWAYS(lower(PATHWAY_DIAGRAM)) tablespace &prod_tablspc;

create index biopathtv_idx on BIO_PATHWAYS_TV(PATHWAY_DIAGRAM_NAME) tablespace &prod_tablspc;
create index biopathtv_idx_lwr on BIO_PATHWAYS_TV(lower(PATHWAY_DIAGRAM_NAME)) tablespace &prod_tablspc;

create index evid_sent on EVIDENCE(SENTENCE_SUBSTR) tablespace &prod_tablspc;
create index evid_sent_lwr on EVIDENCE(lower(SENTENCE_SUBSTR)) tablespace &prod_tablspc;

create index hist_close_idx on HISTOLOGY_CLOSURE(HIERARCHY_LEVEL) tablespace &prod_tablspc;
create index hist_close_lwr_idx on HISTOLOGY_CLOSURE(lower(HIERARCHY_LEVEL)) tablespace &prod_tablspc;

create index hist_code_idx on HISTOLOGY_CODE(HISTOLOGY_NAME) tablespace &prod_tablspc;
create index hist_code_lwr_idx on HISTOLOGY_CODE(lower(HISTOLOGY_NAME)) tablespace &prod_tablspc;


create index hist_dis_idx on HISTOPATHOLOGY_DISEASE(DISEASE_ID_V) tablespace &prod_tablspc;
create index hist_dis_lwr_idx on HISTOPATHOLOGY_DISEASE(lower(DISEASE_ID_V)) tablespace &prod_tablspc;

create index homo_geneid_idx on HOMOLOGOUS_ASSOCIATION(HOMOLOGOUS_GENE_ID) tablespace &prod_tablspc;
create index homo_geneid_lwr_idx on HOMOLOGOUS_ASSOCIATION(lower(HOMOLOGOUS_GENE_ID)) tablespace &prod_tablspc;

create index orgontorel on ORGANONTOLOGYRELATIONSHIP(CHILD_ID_2) tablespace &prod_tablspc;
create index orgontorel_lwr on ORGANONTOLOGYRELATIONSHIP(lower(CHILD_ID_2)) tablespace &prod_tablspc;

create index protocols_idx on PROTOCOLS(CURRENT_STATUS_DATE) tablespace &prod_tablspc;
create index protocols_idx_lwr on PROTOCOLS(lower(CURRENT_STATUS_DATE)) tablespace &prod_tablspc;

create index protocols_lo_idx on PROTOCOLS(LEAD_ORGANIZATION_NAME) tablespace &prod_tablspc;
create index protocols_lo_idx_lwr on PROTOCOLS(lower(LEAD_ORGANIZATION_NAME)) tablespace &prod_tablspc;

create index taxon_abbr_idx on TAXOn(ABBREVIATION) tablespace &prod_tablspc;
create index taxon_abbr_lwr_idx on TAXOn(lower(ABBREVIATION)) tablespace &prod_tablspc;

create index taxon_commname on TAXON(COMMON_NAME) tablespace &prod_tablspc;
create index taxon_commname_lwr on TAXON(lower(COMMON_NAME)) tablespace &prod_tablspc;

@$LOAD/indexer_new.sql chromosome
@$LOAD/indexes/chromosome.cols.sql
@$LOAD/indexes/chromosome.lower.sql
@$LOAD/constraints.sql chromosome
@$LOAD/constraints/chromosome.enable.sql

@$LOAD/constraints/taxon.enable.sql
@$LOAD/constraints/bio_pathways_tv.enable.sql
