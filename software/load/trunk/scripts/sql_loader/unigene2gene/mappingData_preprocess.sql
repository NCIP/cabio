TRUNCATE TABLE zstg_gene2UNIGENE REUSE STORAGE;
TRUNCATE TABLE zstg_omim2gene REUSE STORAGE;
TRUNCATE TABLE zstg_gene2ACCESSION REUSE STORAGE;
TRUNCATE TABLE zstg_geneALIAS REUSE STORAGE;
TRUNCATE TABLE zstg_gene2refseq REUSE STORAGE;
TRUNCATE TABLE zstg_seqgene REUSE STORAGE;
TRUNCATE TABLE zstg_seqsts REUSE STORAGE;
TRUNCATE TABLE ZSTG_REFSEQ2UNIPROT REUSE STORAGE;

@$LOAD/indexer_new.sql zstg_gene2UNIGENE;
@$LOAD/indexer_new.sql zstg_omim2gene;
@$LOAD/indexer_new.sql zstg_gene2ACCESSION;
@$LOAD/indexer_new.sql zstg_geneALIAS;
@$LOAD/indexer_new.sql zstg_gene2refseq;
@$LOAD/indexer_new.sql zstg_seqgene;
@$LOAD/indexer_new.sql zstg_seqsts;
@$LOAD/indexer_new.sql ZSTG_REFSEQ2UNIPROT;

@$LOAD/constraints.sql zstg_gene2UNIGENE;
@$LOAD/constraints.sql zstg_omim2gene;
@$LOAD/constraints.sql zstg_gene2ACCESSION;
@$LOAD/constraints.sql zstg_geneALIAS;
@$LOAD/constraints.sql zstg_gene2refseq;
@$LOAD/constraints.sql zstg_seqgene;
@$LOAD/constraints.sql zstg_seqsts;
@$LOAD/constraints.sql ZSTG_REFSEQ2UNIPROT;

@$LOAD/triggers.sql zstg_gene2UNIGENE;
@$LOAD/triggers.sql zstg_omim2gene;
@$LOAD/triggers.sql zstg_gene2ACCESSION;
@$LOAD/triggers.sql zstg_geneALIAS;
@$LOAD/triggers.sql zstg_gene2refseq;
@$LOAD/triggers.sql zstg_seqgene;
@$LOAD/triggers.sql zstg_seqsts;
@$LOAD/triggers.sql ZSTG_REFSEQ2UNIPROT;

@$LOAD/constraints/zstg_gene2unigene.disable.sql;
@$LOAD/constraints/zstg_omim2gene.disable.sql;
@$LOAD/constraints/zstg_gene2accession.disable.sql;
@$LOAD/constraints/zstg_genealias.disable.sql;
@$LOAD/constraints/zstg_gene2refseq.disable.sql;
@$LOAD/constraints/zstg_seqgene.disable.sql;
@$LOAD/constraints/zstg_seqsts.disable.sql;
@$LOAD/constraints/zstg_refseq2uniprot.disable.sql;

@$LOAD/indexes/zstg_gene2unigene.drop.sql;
@$LOAD/indexes/zstg_omim2gene.drop.sql;
@$LOAD/indexes/zstg_gene2accession.drop.sql;
@$LOAD/indexes/zstg_genealias.drop.sql;
@$LOAD/indexes/zstg_gene2refseq.drop.sql;
@$LOAD/indexes/zstg_seqgene.drop.sql;
@$LOAD/indexes/zstg_seqsts.drop.sql;
@$LOAD/indexes/zstg_refseq2uniprot.drop.sql;


@$LOAD/triggers/zstg_gene2unigene.disable.sql;
@$LOAD/triggers/zstg_omim2gene.disable.sql;
@$LOAD/triggers/zstg_gene2accession.disable.sql;
@$LOAD/triggers/zstg_genealias.disable.sql;
@$LOAD/triggers/zstg_gene2refseq.disable.sql;
@$LOAD/triggers/zstg_seqgene.disable.sql;
@$LOAD/triggers/zstg_seqsts.disable.sql;
@$LOAD/triggers/zstg_refseq2uniprot.disable.sql;

EXIT;
