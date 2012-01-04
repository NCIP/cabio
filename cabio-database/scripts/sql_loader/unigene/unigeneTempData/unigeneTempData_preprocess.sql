TRUNCATE TABLE zstg_hsmm_seq REUSE STORAGE;
TRUNCATE TABLE zstg_gene REUSE STORAGE;
TRUNCATE TABLE zstg_entrez_gene REUSE STORAGE;
TRUNCATE TABLE zstg_refseq_mrna REUSE STORAGE;
TRUNCATE TABLE zstg_gene_markers REUSE STORAGE;
TRUNCATE TABLE zstg_gene_identifiers REUSE STORAGE;
TRUNCATE TABLE gene_nucleic_acid_sequence REUSE STORAGE;

@$LOAD/indexer_new.sql zstg_hsmm_seq;
@$LOAD/indexer_new.sql zstg_gene;
@$LOAD/indexer_new.sql zstg_entrez_gene;
@$LOAD/indexer_new.sql zstg_refseq_mrna;
@$LOAD/indexer_new.sql zstg_gene_markers;
@$LOAD/indexer_new.sql zstg_gene_identifiers;
@$LOAD/indexer_new.sql gene_nucleic_acid_sequence;


@$LOAD/constraints.sql zstg_hsmm_seq;
@$LOAD/constraints.sql zstg_gene;
@$LOAD/constraints.sql zstg_entrez_gene;
@$LOAD/constraints.sql zstg_refseq_mrna;
@$LOAD/constraints.sql zstg_gene_markers;
@$LOAD/constraints.sql zstg_gene_identifiers;
@$LOAD/constraints.sql gene_nucleic_acid_sequence;


@$LOAD/triggers.sql zstg_hsmm_seq;
@$LOAD/triggers.sql zstg_gene;
@$LOAD/triggers.sql zstg_entrez_gene;
@$LOAD/triggers.sql zstg_refseq_mrna;
@$LOAD/triggers.sql zstg_gene_markers;
@$LOAD/triggers.sql zstg_gene_identifiers;
@$LOAD/triggers.sql gene_nucleic_acid_sequence;

@$LOAD/constraints/zstg_hsmm_seq.disable.sql;
@$LOAD/constraints/zstg_gene.disable.sql;
@$LOAD/constraints/zstg_entrez_gene.disable.sql;
@$LOAD/constraints/zstg_refseq_mrna.disable.sql;
@$LOAD/constraints/zstg_gene_markers.disable.sql;
@$LOAD/constraints/zstg_gene_identifiers.disable.sql;
@$LOAD/constraints/gene_nucleic_acid_sequence.disable.sql;

@$LOAD/indexes/zstg_hsmm_seq.drop.sql;
@$LOAD/indexes/zstg_gene.drop.sql;
@$LOAD/indexes/zstg_entrez_gene.drop.sql;
@$LOAD/indexes/zstg_refseq_mrna.drop.sql;
@$LOAD/indexes/zstg_gene_markers.drop.sql;
@$LOAD/indexes/zstg_gene_identifiers.drop.sql;
@$LOAD/indexes/gene_nucleic_acid_sequence.drop.sql;

EXIT;
