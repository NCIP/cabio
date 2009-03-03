#!/bin/sh
echo "Calling Affy HG U133BA MicroArray data parsers"
perl Affy_HG_DataSeparator.pl HT_HG-U133B.annot.csv 1 U133B

echo "Generating SQL Loader specific input data from Affy HG U133B  MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_1.txt representative_public_ID_out_1.txt representative_public_ID_out_1.log U133B 
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_1.txt unigene_ID_out_1.txt unigene_ID_out_1.log U133B
perl Affy_HG_DataFormatter.pl gene_title_file_out_1.txt gene_title_out_1.txt gene_title_out_1.log U133B
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_1.txt gene_symbol_out_1.txt gene_symbol_out_1.log U133B

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_1.txt chromosomal_location_out_1.txt U133B

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_1.txt entrez_gene_out_1.txt entrez_gene_out_1.log U133B
perl Affy_HG_DataFormatter.pl swissprot_file_out_1.txt swissprot_out_1.txt swissprot_out_1.log U133B
perl Affy_HG_DataFormatter.pl OMIM_file_out_1.txt OMIM_out_1.txt OMIM_out_1.log U133B
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_1.txt refseq_protein_id_out_1.txt refseq_protein_id_out_1.log U133B
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_1.txt refseq_transcript_id_out_1.txt refseq_transcript_id_out_1.log U133B

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_1.txt go_biological_process_out_1.txt U133B
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_1.txt go_cellular_component_out_1.txt U133B
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_1.txt go_molecular_function_out_1.txt U133B
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_1.txt pathway_out_1.txt U133B
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_1.txt alignments_out_1.txt U133B
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_1.txt interpro_out_1.txt U133B

###############################################################
# Generate for second type of array

perl Affy_HG_DataSeparator.pl HG-U133B.annot.csv 2 U133B

echo "Generating SQL Loader specific input data from Affy HG U133B_2 MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_2.txt representative_public_ID_out_2.txt representative_public_ID_out_2.log  U133B
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_2.txt unigene_ID_out_2.txt unigene_ID_out_2.log U133B
perl Affy_HG_DataFormatter.pl gene_title_file_out_2.txt gene_title_out_2.txt gene_title_out_2.log U133B
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_2.txt gene_symbol_out_2.txt gene_symbol_out_2.log U133B

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_2.txt chromosomal_location_out_2.txt U133B

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_2.txt entrez_gene_out_2.txt entrez_gene_out_2.log U133B
perl Affy_HG_DataFormatter.pl swissprot_file_out_2.txt swissprot_out_2.txt swissprot_out_2.log U133B
perl Affy_HG_DataFormatter.pl OMIM_file_out_2.txt OMIM_out_2.txt OMIM_out_2.log U133B
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_2.txt refseq_protein_id_out_2.txt refseq_protein_id_out_2.log U133B
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_2.txt refseq_transcript_id_out_2.txt refseq_transcript_id_out_2.log U133B

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_2.txt go_biological_process_out_2.txt U133B
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_2.txt go_cellular_component_out_2.txt U133B
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_2.txt go_molecular_function_out_2.txt U133B
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_2.txt pathway_out_2.txt U133B
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_2.txt alignments_out_2.txt U133B
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_2.txt interpro_out_2.txt U133B

echo "Finished generating SQL Loader input files for Affymetrix HG_U133B  MicroArray Data"
#############################################################

echo "Finished generating SQL Loader input files for Affymetrix HG_U133B  MicroArray Data"
