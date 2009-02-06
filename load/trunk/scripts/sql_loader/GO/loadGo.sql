TRUNCATE TABLE go_ontology REUSE STORAGE;
TRUNCATE TABLE go_relationship REUSE STORAGE;
TRUNCATE TABLE zstg_gene_ontology REUSE STORAGE;
TRUNCATE TABLE go_genes REUSE STORAGE;

@$LOAD/indexer_new.sql go_ontology
@$LOAD/indexer_new.sql go_relationship
@$LOAD/indexer_new.sql zstg_gene_ontology
@$LOAD/indexer_new.sql go_genes

@$LOAD/constraints.sql go_ontology
@$LOAD/constraints.sql go_relationship
@$LOAD/constraints.sql zstg_gene_ontology
@$LOAD/constraints.sql go_genes

@$LOAD/triggers.sql go_ontology
@$LOAD/triggers.sql go_relationship
@$LOAD/triggers.sql zstg_gene_ontology
@$LOAD/triggers.sql go_genes

@$LOAD/constraints/go_ontology.disable.sql;
@$LOAD/constraints/go_relationship.disable.sql;
@$LOAD/constraints/zstg_gene_ontology.disable.sql;
@$LOAD/constraints/go_genes.disable.sql;

@$LOAD/triggers/go_ontology.disable.sql;
@$LOAD/triggers/go_relationship.disable.sql;
@$LOAD/triggers/zstg_gene_ontology.disable.sql;
@$LOAD/triggers/go_genes.disable.sql;


@$LOAD/indexes/go_ontology.drop.sql;
@$LOAD/indexes/go_relationship.drop.sql;
@$LOAD/indexes/zstg_gene_ontology.drop.sql;
@$LOAD/indexes/go_genes.drop.sql;

INSERT INTO go_ontology(go_id,go_name,hs_genes,mm_genes) SELECT a.go_id, a.go_name, hs_count, mm_count FROM (SELECT g.go_id, g.go_name, NVL (COUNT(UNIQUE c.cluster_number), 0) hs_count FROM CGAP.GO_NAME@WEB.NCI.NIH.GOV g, CGAP.LL_GO@WEB.NCI.NIH.GOV l, CGAP.hs_cluster@WEB.NCI.NIH.GOV c
WHERE  g.go_id = l.go_id (+) AND  l.ll_id = c.locuslink (+) GROUP BY g.go_id, g.go_name) a,
(SELECT g.go_id, g.go_name, NVL (COUNT (UNIQUE c.cluster_number), 0) MM_count FROM CGAP.GO_NAME@WEB.NCI.NIH.GOV g, CGAP.LL_GO@WEB.NCI.NIH.GOV l, CGAP.MM_cluster@WEB.NCI.NIH.GOV c WHERE  g.go_id = l.go_id (+) AND  l.ll_id = c.locuslink (+) GROUP BY g.go_id, g.go_name) b WHERE a.go_id = b.go_id;
COMMIT;

INSERT INTO go_relationship (child_id, parent_id,relationship)SELECT DISTINCT go_id,go_parent_ID,PARENT_TYPE FROM CGAP.GO_PARENT@WEB.NCI.NIH.GOV;
COMMIT;

INSERT INTO zstg_gene_ontology(GO_ID, organISM,LOCUS_ID)SELECT   TO_NUMBER(GO_ID) GO_ID, DECODE(organism, 'Hs', 5, 'Mm', 6) ORGANISM,LL_ID FROM  CGAP.LL_GO@WEB.NCI.NIH.GOV;

INSERT INTO go_genes(gene_id,go_id,taxon_id)SELECT gene_id,go_id,organism FROM  zstg_gene_ontology GOT, zstg_gene_identifiers GI WHERE  GI.IDENTIFIER = GOT.LOCUS_ID AND  GI.data_source = 2;

@$LOAD/indexes/go_ontology.cols.sql;
@$LOAD/indexes/go_ontology.lower.sql;
@$LOAD/indexes/go_relationship.cols.sql;
@$LOAD/indexes/go_relationship.lower.sql;
@$LOAD/indexes/zstg_gene_ontology.cols.sql;
@$LOAD/indexes/go_genes.lower.sql;

@$LOAD/constraints/go_ontology.enable.sql;
@$LOAD/constraints/go_genes.enable.sql;
@$LOAD/constraints/go_relationship.enable.sql;
@$LOAD/constraints/zstg_gene_ontology.enable.sql;

@$LOAD/triggers/go_ontology.enable.sql;
@$LOAD/triggers/go_relationship.enable.sql;
@$LOAD/triggers/zstg_gene_ontology.enable.sql;
COMMIT;
--execute Load_Heir.MakeClosure;
EXIT;
