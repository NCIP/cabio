/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- Loads the KEYWORDS table for auto-completion
--

-- This view is used to select from STG_KEYWORD and insert into STG_KEYWORD_AGG. 
-- 
-- STG_KEYWORD
-- brca1, 189
-- stim1, 300
-- rps5, 300
-- brca2, 6280
-- 
-- Order distinct scores: (6280,300,189)
-- 
-- Assign new ordinal scores: 6280->1, 300->2, 189->3
-- 
-- STG_KEYWORD_AGG
-- brca1, 3, Gene
-- stim1, 2, Gene
-- rps5, 2, Gene
-- brca2, 1, Gene
-- 
-- The purpose of this step is normalization across classes. It ensures that 
-- scores are intermingled across types (Gene, Disease, etc).
-- 
CREATE OR REPLACE VIEW STG_KEYWORD_NORM AS
select kw.value value, ord.num score from 
    (select rownum num, score from 
        (select distinct score 
         from STG_KEYWORD 
         where score != 0
         order by score desc)
    ) ord, STG_KEYWORD kw
where ord.score = kw.score
and kw.value is not null
and length(trim(kw.value)) > 3
and length(trim(kw.value)) < 80;

-- Now load keywords from each type into the STG_KEYWORD table and then 
-- transfer to STG_KEYWORD_AGG. The score is the sum of cardinalities of 
-- important associations.

-- Disease

truncate table STG_KEYWORD_AGG;
truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(h.HISTOLOGY_NAME) value, 
    (select count(*) from GENE_FUNCTION_ASSOCIATION where HISTOLOGYCODE_ID = h.HISTOLOGY_CODE) +
    (select count(*) from PROTOCOL_HISTOLOGY where HISTOLOGY_CODE = h.HISTOLOGY_CODE) +
    (select count(*) from HISTOPATHOLOGY_TST where HISTOLOGY_CODE = h.HISTOLOGY_CODE) score
    from HISTOLOGY_CODE h
) 
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Disease', value, score from STG_KEYWORD_NORM;

-- Agent

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(a.AGENT_NAME) value, 
    (select count(*) from GENE_FUNCTION_ASSOCIATION where AGENT_ID = a.AGENT_ID) +
    (select count(*) from PROTOCOL_AGENTS where AGENT_ID = a.AGENT_ID) +
    (select count(*) from PID_ENTITY_AGENT where AGENT_ID = a.AGENT_ID) score
    from AGENT a
)
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Agent', value, score from STG_KEYWORD_NORM;

-- Organ

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(t.TISSUE_NAME) value, 
    (select count(*) from GENE_EXPRESSED_IN where ORGAN_ID = t.TISSUE_CODE) +
    (select count(*) from HISTOPATHOLOGY_TST where TISSUE_CODE = t.TISSUE_CODE) +
    (select count(*) from ANOMALY_TISSUE_CODE where TISSUE_CODE = t.TISSUE_CODE) score
    from TISSUE_CODE t
)
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Organ', value, score from STG_KEYWORD_NORM;

-- Gene

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(g.SYMBOL) value, 
    (select count(*) from ARRAY_REPORTER_CH where GENE_ID = g.GENE_ID) +
    (select count(*) from GENE_FUNCTION_ASSOCIATION where GENE_ID = g.GENE_ID) +
    (select count(*) from GENE_HISTOPATHOLOGY where GENE_ID = g.GENE_ID) score
    from GENE_TV g
)
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Gene', value, score from STG_KEYWORD_NORM;

-- Protein Domains

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(p.DESCRIPTION) value, 
    (select count(*) from EXPR_REPORTER_PROTEIN_DOMAIN where PROTEIN_DOMAIN_ID = p.ID) score
    from PROTEIN_DOMAIN p
)
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Protein Domain', value, score from STG_KEYWORD_NORM;

-- Pathways

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
select value, sum(score) from (
    select lower(p.PATHWAY_NAME) value, 
    (select count(*) from PATHWAY_GENE_OBJECT where PATHWAY_ID = p.PATHWAY_ID) +
    (select count(*) from PATHWAY_CONTEXT_OBJECT where PATHWAY_ID = p.PATHWAY_ID) +
    (select count(*) from PID_PATHWAY_INTERACTION where PATHWAY_ID = p.PATHWAY_ID) score
    from BIO_PATHWAYS_TV p
)
group by value;

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
-- artificially deflate pathway scores so that they don't show up unless the user types
-- the h_ or m_ underscore.
select 'Pathway', value, score+50 from STG_KEYWORD_NORM;

-- Protein keywords

truncate table STG_KEYWORD;
insert into STG_KEYWORD (VALUE, SCORE)
    select lower(p.keyword) value, count(*) score
    from PROTEIN_KEYWORDS p
    where p.keyword is not null
    group by lower(p.keyword);

insert into STG_KEYWORD_AGG (TYPE, VALUE, SCORE)
select 'Protein keyword', value, score from STG_KEYWORD_NORM;

-- Normalize and load into final user-space table

var max_score number;
exec select max(SCORE) into :max_score from STG_KEYWORD_AGG;

DROP SEQUENCE KEYWORD_SEQ;
CREATE SEQUENCE KEYWORD_SEQ;

truncate table KEYWORD;

insert into KEYWORD (ID, VALUE, SCORE)
    -- assign internal ids
    select KEYWORD_SEQ.NEXTVAL, f.* from (
        -- order by score for faster searches
        select value, score from (
            -- flip scores and sum across classes
            select VALUE, sum(:max_score-SCORE) score
            from STG_KEYWORD_AGG
            group by VALUE
        )
        order by score desc
    ) f;

commit;

-- Index and analyze

create index keyword_value_index on KEYWORD(value);
analyze table KEYWORD compute statistics;

exit;
