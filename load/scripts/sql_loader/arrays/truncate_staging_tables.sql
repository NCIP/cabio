-- Truncate all array staging tables.
-- These tables will be loaded with SQL*Loader
TRUNCATE TABLE ar_alignments REUSE STORAGE;
TRUNCATE TABLE ar_alignments_tmp REUSE STORAGE;
TRUNCATE TABLE ar_chromosomal_location REUSE STORAGE;
TRUNCATE TABLE ar_chromosomal_location_tmp REUSE STORAGE;
TRUNCATE TABLE ar_entrez_gene REUSE STORAGE;
TRUNCATE TABLE ar_entrez_gene_tmp REUSE STORAGE;
TRUNCATE TABLE ar_ec REUSE STORAGE;
TRUNCATE TABLE ar_ec_tmp REUSE STORAGE;
TRUNCATE TABLE ar_gene_symbol REUSE STORAGE;
TRUNCATE TABLE ar_gene_symbol_tmp REUSE STORAGE;
TRUNCATE TABLE ar_gene_title REUSE STORAGE;
TRUNCATE TABLE ar_gene_title_tmp REUSE STORAGE;
TRUNCATE TABLE ar_go_biological_process REUSE STORAGE;
TRUNCATE TABLE ar_go_biological_process_tmp REUSE STORAGE;
TRUNCATE TABLE ar_go_cellular_component REUSE STORAGE;
TRUNCATE TABLE ar_go_cellular_component_tmp REUSE STORAGE;
TRUNCATE TABLE ar_go_molecular_function REUSE STORAGE;
TRUNCATE TABLE ar_go_molecular_function_tmp REUSE STORAGE;
TRUNCATE TABLE ar_omim_id REUSE STORAGE;
TRUNCATE TABLE ar_omim_id_tmp REUSE STORAGE;
TRUNCATE TABLE ar_pathway REUSE STORAGE;
TRUNCATE TABLE ar_pathway_tmp REUSE STORAGE;
TRUNCATE TABLE ar_refseq_protein REUSE STORAGE;
TRUNCATE TABLE ar_refseq_protein_tmp REUSE STORAGE;
TRUNCATE TABLE ar_refseq_transcripts REUSE STORAGE;
TRUNCATE TABLE ar_refseq_transcripts_TMP REUSE STORAGE;
TRUNCATE TABLE ar_representative_public_id REUSE STORAGE;
TRUNCATE TABLE ar_rep_public_id_tmp REUSE STORAGE;
TRUNCATE TABLE ar_rna_probesets_affy REUSE STORAGE;
TRUNCATE TABLE ar_rna_probesets_affy_tmp REUSE STORAGE;
TRUNCATE TABLE ar_swissprot REUSE STORAGE;
TRUNCATE TABLE ar_swissprot_tmp REUSE STORAGE;
TRUNCATE TABLE ar_unigene_id REUSE STORAGE;
TRUNCATE TABLE ar_unigene_id_TMP REUSE STORAGE;
TRUNCATE TABLE ar_ensembl REUSE STORAGE;
TRUNCATE TABLE ar_ensembl_tmp REUSE STORAGE;
TRUNCATE TABLE zstg_snp_affy REUSE STORAGE;
TRUNCATE TABLE zstg_rna_probesets REUSE STORAGE;
TRUNCATE TABLE zstg_rna_probesets_tmp REUSE STORAGE;
TRUNCATE TABLE zstg_rna_agilent REUSE STORAGE;
TRUNCATE TABLE zstg_cgh_agilent REUSE STORAGE;
TRUNCATE TABLE zstg_cgh_accessions REUSE STORAGE;
TRUNCATE TABLE zstg_snp_illumina REUSE STORAGE;
TRUNCATE TABLE zstg_pop_frequency REUSE STORAGE;
TRUNCATE TABLE zstg_interpro REUSE STORAGE;
TRUNCATE TABLE zstg_interpro_tmp REUSE STORAGE;
TRUNCATE TABLE zstg_geneTIC_MAP REUSE STORAGE;
TRUNCATE TABLE zstg_microsatellite REUSE STORAGE;
TRUNCATE TABLE zstg_exon_affy REUSE STORAGE;
TRUNCATE TABLE zstg_exon_trans_affy REUSE STORAGE;
TRUNCATE TABLE zstg_exon_trans_genes REUSE STORAGE;
TRUNCATE TABLE zstg_snp_associated_gene REUSE STORAGE;
TRUNCATE TABLE zstg_microarray_versions REUSE STORAGE;

-- Drop indexes for faster loading.
-- They will be recreated in update_arrays.sql before the tables are used.
DROP INDEX CGH_ACC_PSI_INDEX ;
DROP INDEX CGH_ACC_ACC_INDEX ;
DROP INDEX CGH_ACC_IND_INDEX ;
DROP INDEX ZSA_DBSNP_INDEX ;
DROP INDEX ZSI_DBSNP_INDEX ;

