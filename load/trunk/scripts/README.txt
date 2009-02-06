
# To run the loader on QA31:

cd scripts
load_qa31.sh

# Automatic data loading execution 

load_[tier].sh
	load_g.sh ("generic")
    
	    download/download.sh
	    	download_cytoband.sh
			download_ncbi_snp.sh
			download_protein.sh
			download_tsc_snp.sh
			download_image_clone.sh
			download_entgene.sh
			download_relative_clone.sh

	    parse/parse_other.sh (run in parallel with parseAll.sh)
			snp_parser.sh
				snp_parser.pl
			uniprot_parser.sh
				uniprot_parser.pl
	    	image_clone_perl_total.sh
				image_clone_total.pl
				
		../unigeneparser/scripts/parseAll.sh 
			ant build (build the unigeneparser if necessary)
		    readLocation.sh
		        readmRNAHs.sh
		        readmRNAMm.sh
		        readESTHs.sh
		        readESTMm.sh
		    runReadData_g.sh
		    runseq_g.sh
	
		sql_scripts/truncate_table_other.sql
		
		sql_loader/sql_ldr_g.sh	
			SNP_other_total.sh
			RNA_affy_total.sh
			protein_load_total.sh
			image_clone_total.sh
			cytoband_total.sh
			unigene2gene_sqlldr.sh
			unigene_sqlldr.sh
			sequence_sqlldrab.sh
			all_est_mrna_sqlldr.sh
	
		load.sql
			arrays/truncate_tables.sql
			Gene2protein.sql
			update_biopathway.sql
			also:
				- drop/create many indexes
				- run some SQL updates/deletes
		
		(grididloader)
			ant -Dtarget.env=[tier]
				
# Automatic array annotation loading execution

scripts/load_arrays_g.sh

	parse_arrays.sh
		RNA_affy.sh
		mapping_parser.sh
		
	truncate_table_arrays.sql
	
	sql_ldr_arrays_g.sh
		SNP_affy.sh
			SNP_AFFY_STG.ctl
			SNP_associated_gene.ctl
		RNA_affy_total.sh
			AR_*.ctl
			ZSTG_RNA_Probesets.ctl


