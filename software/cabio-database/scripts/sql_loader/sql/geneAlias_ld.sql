/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE cgap_gene_alias REUSE STORAGE;
@$LOAD/indexer_new.sql cgap_gene_alias
@$LOAD/constraints.sql cgap_gene_alias
@$LOAD/triggers.sql cgap_gene_alias

@$LOAD/indexer_new.sql gene_alias_object_tv
@$LOAD/constraints.sql gene_alias_object_tv
@$LOAD/triggers.sql gene_alias_object_tv

@$LOAD/indexer_new.sql gene_genealias
@$LOAD/constraints.sql gene_genealias
@$LOAD/triggers.sql gene_genealias

@$LOAD/constraints/cgap_gene_alias.disable.sql;
@$LOAD/triggers/cgap_gene_alias.disable.sql;
@$LOAD/indexes/cgap_gene_alias.drop.sql;

@$LOAD/constraints/gene_alias_object_tv.disable.sql;
@$LOAD/triggers/gene_alias_object_tv.disable.sql;
@$LOAD/indexes/gene_alias_object_tv.drop.sql;

@$LOAD/constraints/gene_genealias.disable.sql;
@$LOAD/triggers/gene_genealias.disable.sql;
@$LOAD/indexes/gene_genealias.drop.sql;

INSERT INTO cgap_gene_alias(gene_id, alias) SELECT * FROM (SELECT distinct (SELECT distinct gene_id FROM gene_tv WHERE GENE_TV.CLUSTER_ID=cGENE.CLUSTER_NUMBER AND GENE_TV.taxon_id = 5) id,GENE FROM cgap.HS_CLUSTER@WEB.NCI.NIH.GOV cgene) WHERE id IS NOT NULL AND GENE IS NOT NULL UNION SELECT * FROM (SELECT distinct (SELECT distinct gene_id FROM GENE_TV WHERE GENE_TV.CLUSTER_ID=cGENE.CLUSTER_NUMBER AND GENE_TV.taxon_id = 6) id,GENE FROM cgap.MM_CLUSTER@WEB.NCI.NIH.GOV cgene) WHERE id IS NOT NULL AND GENE IS NOT NULL;

@$LOAD/constraints/cgap_gene_alias.enable.sql;
@$LOAD/indexes/cgap_gene_alias.cols.sql;
@$LOAD/indexes/cgap_gene_alias.lower.sql;

-- Before this add a trigger that starts updating gene_alias_id --

DROP SEQUENCE gene_ALIAS_ID_SEQ;
CREATE SEQUENCE gene_ALIAS_ID_SEQ;

ALTER TRIGGER gene_ALIAS_ID_LOAD enable;
TRUNCATE TABLE gene_alias_object_tv REUSE STORAGE;
TRUNCATE TABLE gene_genealias REUSE STORAGE;

INSERT INTO gene_alias_object_tv(GENE_ALIAS_ID,ALIAS_TYPE, NAME, GENE_ID) SELECT GENE_ALIAS_ID_SEQ.nextval, ALIAS_TYPE,NAME,GENE_ID from GENE_ALIAS_OBJECT;
commit;

-- Add new aliases from Entrez  and HUGO --
--INSERT INTO gene_alias_object_tv(ALIAS_TYPE, NAME) SELECT distinct TYPE, trim(SYNONYMS) from zstg_geneALIAS a, zstg_gene2unigene b, gene_tv c where a.locuslinkid = b.geneid and b.UCLUSTER=c.CLUSTER_ID and SYNONYMS not like '%-%' and SYNONYMS is NOT NULL and b.taxon=c.taxon_id;
--commit;

--INSERT INTO gene_alias_object_tv(ALIAS_TYPE, NAME) SELECT distinct TYPE, trim(SYNONYMS) from zstg_geneALIAS a, zstg_gene2unigene b, gene_tv c where a.locuslinkid = b.geneid and b.geneid=c.ENTREZ_ID and SYNONYMS not like '%-%' and SYNONYMS is NOT NULL and b.taxon=c.taxon_id and c.cluster_id is null;
--commit;

--TRUNCATE TABLE gene_genealias REUSE STORAGE;
--INSERT INTO gene_genealias(GENE_ID, GENE_ALIAS_ID) select distinct b.GENE_ID,a.GENE_ALIAS_ID from gene_alias_object_tv a, gene_tv b, zstg_geneALIAS c,zstg_gene2unigene d where lower(trim(a.NAME)) = lower(trim(c.SYNONYMS)) and c.locuslinkid = d.geneid and d.UCLUSTER=b.CLUSTER_ID and b.GENE_ID is not null and a.GENE_ALIAS_ID is not null;
--commit;

--INSERT INTO gene_genealias(GENE_ID, GENE_ALIAS_ID) select distinct b.GENE_ID,a.GENE_ALIAS_ID from gene_alias_object_tv a, gene_tv b, zstg_geneALIAS c,zstg_gene2unigene d where lower(trim(a.NAME)) = lower(trim(c.SYNONYMS)) and c.locuslinkid = d.geneid and d.geneid=b.ENTREZ_ID and b.GENE_ID is not null and a.GENE_ALIAS_ID is not null and b.cluster_id is null minus select distinct gene_id, gene_alias_id from gene_genealias;
--commit;

insert into gene_alias_object_tv (alias_type, gene_id, name)
select distinct  type, g.gene_id, synonyms from zstg_genealias a, gene_tv g
       where a.locuslinkid = g.entrez_id and synonyms is not null and trim(synonyms) not like '% %';
commit;


insert into gene_genealias(gene_id, gene_alias_id) select gene_id, gene_alias_id from gene_alias_object_tv where gene_id is not null;

commit;



@$LOAD/indexes/gene_alias_object_tv.cols.sql;
@$LOAD/indexes/gene_alias_object_tv.lower.sql;
@$LOAD/constraints/gene_alias_object_tv.enable.sql;
@$LOAD/triggers/gene_alias_object_tv.enable.sql;

@$LOAD/indexes/gene_genealias.cols.sql;
@$LOAD/indexes/gene_genealias.lower.sql;
@$LOAD/constraints/gene_genealias.enable.sql;
@$LOAD/triggers/gene_genealias.enable.sql;

EXIT;
