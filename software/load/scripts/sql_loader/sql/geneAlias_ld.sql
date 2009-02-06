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

--INSERT INTO gene_alias_object_tv(GENE_ALIAS_ID,ALIAS_TYPE, NAME, GENE_ID) SELECT GENE_ALIAS_ID_SEQ.nextval, ALIAS_TYPE,NAME,GENE_ID from GENE_ALIAS_OBJECT;

-- Add new aliases from Entrez  and HUGO --
INSERT INTO gene_alias_object_tv(ALIAS_TYPE, NAME) SELECT distinct TYPE, trim(SYNONYMS) from zstg_geneALIAS a, zstg_gene2unigene b, gene_tv c where a.locuslinkid = b.geneid and substr(b.UNIGENE_CLUSTER, instr(b.unigene_cluster,'.')+1)=c.CLUSTER_ID and SYNONYMS not like '%-%' and SYNONYMS is NOT NULL and decode(substr(b.unigene_cluster,0,2),'Hs',5, 'Mm',6) = c.taxon_id;

TRUNCATE TABLE gene_genealias REUSE STORAGE;
INSERT INTO gene_genealias(GENE_ID, GENE_ALIAS_ID) select distinct b.GENE_ID,a.GENE_ALIAS_ID from gene_alias_object_tv a, gene_tv b, zstg_geneALIAS c,zstg_gene2unigene d where a.NAME = c.SYNONYMS and c.locuslinkid = d.geneid and substr(d.UNIGENE_CLUSTER, instr(d.unigene_cluster,'.')+1)=b.CLUSTER_ID and b.GENE_ID is not null and a.GENE_ALIAS_ID is not null;

@$LOAD/constraints/gene_alias_object_tv.enable.sql;
@$LOAD/triggers/gene_alias_object_tv.enable.sql;
@$LOAD/indexes/gene_alias_object_tv.cols.sql;
@$LOAD/indexes/gene_alias_object_tv.lower.sql;

@$LOAD/constraints/gene_genealias.enable.sql;
@$LOAD/triggers/gene_genealias.enable.sql;
@$LOAD/indexes/gene_genealias.cols.sql;
@$LOAD/indexes/gene_genealias.lower.sql;

EXIT;
