@$LOAD/indexes/zstg_gene.cols.sql;
@$LOAD/indexes/zstg_entrez_gene.cols.sql;
@$LOAD/indexes/zstg_refseq_mrna.cols.sql;
@$LOAD/indexes/zstg_gene_markers.cols.sql;
@$LOAD/indexes/zstg_hsmm_seq.cols.sql;
@$LOAD/indexes/zstg_gene_identifiers.cols.sql;
@$LOAD/indexes/gene_nucleic_acid_sequence.cols.sql;

@$LOAD/constraints/zstg_gene.enable.sql;
@$LOAD/constraints/zstg_refseq_mrna.enable.sql;
@$LOAD/constraints/zstg_gene_markers.enable.sql;
@$LOAD/constraints/zstg_hsmm_seq.enable.sql;
@$LOAD/constraints/zstg_gene_identifiers.enable.sql;
@$LOAD/constraints/gene_nucleic_acid_sequence.enable.sql;

@$LOAD/triggers/zstg_gene.enable.sql;
@$LOAD/triggers/zstg_refseq_mrna.enable.sql;
@$LOAD/triggers/zstg_gene_markers.enable.sql;
@$LOAD/triggers/zstg_hsmm_seq.enable.sql;
@$LOAD/triggers/zstg_gene_identifiers.enable.sql;
@$LOAD/triggers/gene_nucleic_acid_sequence.enable.sql;

ANALYZE TABLE zstg_gene COMPUTE STATISTICS;
ANALYZE TABLE zstg_entrez_gene COMPUTE STATISTICS;
ANALYZE TABLE zstg_refseq_mrna COMPUTE STATISTICS;
ANALYZE TABLE zstg_hsmm_seq COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene_identifiers COMPUTE STATISTICS;
ANALYZE TABLE gene_nucleic_acid_sequence COMPUTE STATISTICS;


EXIT;


