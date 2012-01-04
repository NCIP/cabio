#!/bin/sh
echo "Calling Affy  Hu6800A MicroArray data parsers"
perl Affy_HG_DataSeparator.pl Hu6800.annot.csv 1 Hu6800
perl ../Affy_RemoveComments.pl  Hu6800.annot.csv Hu6800.annot_out.csv Hu6800

echo "Generating SQL Loader specific input data from Affy  Hu6800  MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_1.txt representative_public_ID_out_1.txt representative_public_ID_out_1.log Hu6800 
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_1.txt unigene_ID_out_1.txt unigene_ID_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl gene_title_file_out_1.txt gene_title_out_1.txt gene_title_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_1.txt gene_symbol_out_1.txt gene_symbol_out_1.log Hu6800

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_1.txt chromosomal_location_out_1.txt Hu6800

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_1.txt entrez_gene_out_1.txt entrez_gene_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl swissprot_file_out_1.txt swissprot_out_1.txt swissprot_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl OMIM_file_out_1.txt OMIM_out_1.txt OMIM_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_1.txt refseq_protein_id_out_1.txt refseq_protein_id_out_1.log Hu6800
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_1.txt refseq_transcript_id_out_1.txt refseq_transcript_id_out_1.log Hu6800

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_1.txt go_biological_process_out_1.txt Hu6800
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_1.txt go_cellular_component_out_1.txt Hu6800
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_1.txt go_molecular_function_out_1.txt Hu6800
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_1.txt pathway_out_1.txt Hu6800
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_1.txt alignments_out_1.txt Hu6800
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_1.txt interpro_out_1.txt Hu6800


echo "Finished generating SQL Loader input files for Affymetrix Hu6800  MicroArray Data"
