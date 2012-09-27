
# The caBIO Release 4.3.2 data refresh directory is cabio432_load
# To run the data refresh for release 4.3.2

cd cabio432_load/scripts

# modify the environment variables in setup_env.sh to have the correct environment variables
# run setup_env.sh to set up the correct environment variables before running the data refresh scripts

source setup_env.sh

# run load_g.sh to automatically download, parsing and database loading.  The script calls scripts 
# under the download subdirectory to download source files, scripts under the parse subdirectory to parse
# the downloaded source files, and scripts under the sql_loader subdirectory to load the files into
# the database.  The script also loads the required data from the CGAP database (this step is required 
# before parsing).  

load_g.sh

##### LOGIC with load_g.sh #####

#### DOWNLOAD ####
   
# Automatically downloads non array data (UCSC_Cytoband, NCBI_SNP, TSC_SNP, 
# Uniprot, NCBI_GeneIdMapping, UCSC_EST, UCSC_mRNA, NCBI_Unigene, CTEP, UniSTS, 
# gene alias, Drugbank, and Compara data).

# Notes: 
#	PID data is now manually downloaded.  
#	Affymetrix, Agilent and Illunima files are manually downloaded.
#	The script still downloads the old Drug Card format (version 2.5 in January 2009) 
#   for Canada Drug Bank data.  A new parser needs to be written to parse the Canada Drug Bank data 
#   in XML format.
  	
	    download/Download_NonArray_Data.sh
	    
	    	download_HumanAndMouseCytobandData_UCSC.sh  
			download_SNPData_NCBI.sh  
			download_SNPData_TSC.sh 
			download_ProteinData_Uniprot.sh 
			download_GeneIdMappingsData_NCBI.sh  
			download_ESTAnnotationsData_UCSC.sh 
			download_Mrna_UCSC.sh 
			download_Unigene_NCBI.sh  
			download_CTEPData.sh 
			download_Marker.sh 
			download_GeneAlias.sh 
			download_Drugbank.sh 
			download_Compara.pl
	
##### PARSE #####

#  parses NCBI SNP, Uniprot, Cytoband, UniSTS, Gene Aliases, EST, mRNA and Unigene data
		
		parse/Parse_NonMicroArray_Data.sh 
		
			drugbank/drug_parser.pl
			snp/NCBI_Snp_DataParser.sh 
			protein/Uniprot_Protein_DataParser.sh 
			cytoband/UCSC_Cytoband_DataParser.sh
			marker/markerAlias.pl 
			marker/markerParse.pl
			geneAlias/geneAliasParser.sh
			unigeneparser/scripts/parseAll.sh
				
				unigeneparser/scripts/generateCRL.sh
				unigeneparser/scripts/generateNas.sh
				unigeneparser/scripts/readESTHs.sh
				unigeneparser/scripts/readESTMm.sh
				unigeneparser/scripts/readLocation.sh
				unigeneparser/scripts/readmRefSeqHs.sh
				unigeneparser/scripts/readmRefSeqMm.sh
				unigeneparser/scripts/readmRNAHs.sh
				unigeneparser/scripts/readmRNAMm.sh
				unigeneparser/scripts/runReadData_g.sh
				unigeneparser/scripts/runseq_g.sh
				unigeneparser/scripts/clone_seq_end.pl
			
		
#  parses microarray annotations data from Affymetrix, Agilent and Illumina
		
		parse/Parse_MicroArray_Data.sh 
		
	    	arrays/processFileNames.pl 
			arrays/Affymetrix/HG-U133_Plus2/Affymetrix_HG_U133_Plus2_DataParser.sh 
			arrays/Affymetrix/HG-U133/Affymetrix_HG_U133_DataParser.sh
			arrays/Affymetrix/HuMapping/Affymetrix_HuMappingMA_DataParser.sh
			arrays/Affymetrix/HG-U95-U133B-6800/Affy_HGU95_DataParser.sh
			arrays/Affymetrix/HG-U95-U133B-6800/ Affy_HGU133B_DataParser.sh
			arrays/Affymetrix/HG-U95-U133B-6800/Affy_Hu6800_DataParser.sh (commented out)
			arrays/Agilent/aCGH244K/Agilent_CGH_244K_DataParser.sh 
			arrays/Agilent/HumanGenome44K/Agilent_HumanGenome44K_DataParser.sh 
			arrays/Affymetrix/HuEx10ST/exon_parser.sh

##### DATABASE LOADING #####

# loads parsed data files into the database in the following order.  

		sql_loader/scripts_load.sh
		
			arrays/sql_ldr_arrays_g.sh
			snp/NCBI_SNPData_SQLLdr_DataLoader.sh
			protein/UniprotProtein_SQLLdr_DataLoader.sh
			unigene/gene/geneTv_sqlldr.sh
			unigene/nas/nas_sqlldr.sh
			unigene/clone/cloneTables_sqlldr.sh
			unigene/unigeneTempData/unigene_sqlldr.sh
			unigene2gene/unigene2gene_sqlldr.sh 
			relative_clone/all_est_mrna_sqlldr.sh
			unigene/unigeneTempData/entrez_load.sh
			cytoband/Cytoband_SQLLdr_DataLoader.sh
			marker/markerLoad.sh
			dbcrossref/DatabaseCrossReference.sh
			homologene/homoloGene_ld.sql
			GO/loadGo.sql
			sql/Gene_Protein_TV_LD.sql
			sql/gene_organontology.sql
			sql/loadPathways.sql
			sql/geneAlias_ld.sql
			location/locationLoad.sh
			histopathology/hist_update.sh
			arrays/load.sh
			cgdc/cgdc_sqlldr.sh
 			pid_dump/pidLoader.sh
 			provenance/provenance_DataLoader.sh
 			keywords/keyword_load.sql
 			arrays/post_bigid_load.sh
 			mergedSnpRsIds_processing/MergedSNPIds_Wrapper.sh
 			location/postbigid.sh
 			compara/load.sh 
			drugbank/load.sh
			ctep/ctep.sh
 			unigene/unigeneTempData/coalse_unigene.sql
 			misc_indexes.sql 
 
