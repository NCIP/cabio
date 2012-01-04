#!/bin/sh
echo "Calling Affy HG U95A MicroArray data parsers"
perl Affy_HG_DataSeparator.pl HG_U95A.annot.csv 1 HG-U95
perl ../Affy_RemoveComments.pl  HG_U95A.annot.csv HG_U95A.annot_out.csv HG-U95


echo "Generating SQL Loader specific input data from Affy HG U95  MicroArray data"

perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_1.txt representative_public_ID_out_1.txt representative_public_ID_out_1.log HG-U95 
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_1.txt unigene_ID_out_1.txt unigene_ID_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl gene_title_file_out_1.txt gene_title_out_1.txt gene_title_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_1.txt gene_symbol_out_1.txt gene_symbol_out_1.log HG-U95

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_1.txt chromosomal_location_out_1.txt HG-U95

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_1.txt entrez_gene_out_1.txt entrez_gene_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl swissprot_file_out_1.txt swissprot_out_1.txt swissprot_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl OMIM_file_out_1.txt OMIM_out_1.txt OMIM_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_1.txt refseq_protein_id_out_1.txt refseq_protein_id_out_1.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_1.txt refseq_transcript_id_out_1.txt refseq_transcript_id_out_1.log HG-U95

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_1.txt go_biological_process_out_1.txt HG-U95
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_1.txt go_cellular_component_out_1.txt HG-U95
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_1.txt go_molecular_function_out_1.txt HG-U95
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_1.txt pathway_out_1.txt HG-U95
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_1.txt alignments_out_1.txt HG-U95
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_1.txt interpro_out_1.txt HG-U95

###############################################################
# Generate for second type of array

perl Affy_HG_DataSeparator.pl HG_U95Av2.annot.csv 2 HG-U95
perl ../Affy_RemoveComments.pl  HG_U95Av2.annot.csv HG_U95Av2.annot_out.csv HG-U95

echo "Generating SQL Loader specific input data from Affy HG U95A_2 MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_2.txt representative_public_ID_out_2.txt representative_public_ID_out_2.log  HG-U95
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_2.txt unigene_ID_out_2.txt unigene_ID_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl gene_title_file_out_2.txt gene_title_out_2.txt gene_title_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_2.txt gene_symbol_out_2.txt gene_symbol_out_2.log HG-U95

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_2.txt chromosomal_location_out_2.txt HG-U95

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_2.txt entrez_gene_out_2.txt entrez_gene_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl swissprot_file_out_2.txt swissprot_out_2.txt swissprot_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl OMIM_file_out_2.txt OMIM_out_2.txt OMIM_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_2.txt refseq_protein_id_out_2.txt refseq_protein_id_out_2.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_2.txt refseq_transcript_id_out_2.txt refseq_transcript_id_out_2.log HG-U95

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_2.txt go_biological_process_out_2.txt HG-U95
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_2.txt go_cellular_component_out_2.txt HG-U95
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_2.txt go_molecular_function_out_2.txt HG-U95
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_2.txt pathway_out_2.txt HG-U95
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_2.txt alignments_out_2.txt HG-U95
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_2.txt interpro_out_2.txt HG-U95

echo "Finished generating SQL Loader input files for Affymetrix HG_U95  MicroArray Data"
#############################################################
# Generate for third type of array

perl Affy_HG_DataSeparator.pl HG_U95B.annot.csv 3 HG-U95
perl ../Affy_RemoveComments.pl  HG_U95B.annot.csv HG_U95B.annot_out.csv HG-U95

echo "Generating SQL Loader specific input data from Affy HT HG U95B MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_3.txt representative_public_ID_out_3.txt representative_public_ID_out_3.log  HG-U95
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_3.txt unigene_ID_out_3.txt unigene_ID_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl gene_title_file_out_3.txt gene_title_out_3.txt gene_title_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_3.txt gene_symbol_out_3.txt gene_symbol_out_3.log HG-U95

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_3.txt chromosomal_location_out_3.txt HG-U95

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_3.txt entrez_gene_out_3.txt entrez_gene_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl swissprot_file_out_3.txt swissprot_out_3.txt swissprot_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl OMIM_file_out_3.txt OMIM_out_3.txt OMIM_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_3.txt refseq_protein_id_out_3.txt refseq_protein_id_out_3.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_3.txt refseq_transcript_id_out_3.txt refseq_transcript_id_out_3.log HG-U95

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_3.txt go_biological_process_out_3.txt HG-U95
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_3.txt go_cellular_component_out_3.txt HG-U95
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_3.txt go_molecular_function_out_3.txt HG-U95
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_3.txt pathway_out_3.txt HG-U95
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_3.txt alignments_out_3.txt HG-U95
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_3.txt interpro_out_3.txt HG-U95
################################################################

# Generate for third type of array

perl Affy_HG_DataSeparator.pl HG_U95C.annot.csv 4 HG-U95
perl ../Affy_RemoveComments.pl  HG_U95C.annot.csv HG_U95C.annot_out.csv HG-U95

echo "Generating SQL Loader specific input data from Affy HT HG U95C MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_4.txt representative_public_ID_out_4.txt representative_public_ID_out_4.log  HG-U95
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_4.txt unigene_ID_out_4.txt unigene_ID_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl gene_title_file_out_4.txt gene_title_out_4.txt gene_title_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_4.txt gene_symbol_out_4.txt gene_symbol_out_4.log HG-U95

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_4.txt chromosomal_location_out_4.txt HG-U95

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_4.txt entrez_gene_out_4.txt entrez_gene_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl swissprot_file_out_4.txt swissprot_out_4.txt swissprot_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl OMIM_file_out_4.txt OMIM_out_4.txt OMIM_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_4.txt refseq_protein_id_out_4.txt refseq_protein_id_out_4.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_4.txt refseq_transcript_id_out_4.txt refseq_transcript_id_out_4.log HG-U95

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_4.txt go_biological_process_out_4.txt HG-U95
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_4.txt go_cellular_component_out_4.txt HG-U95
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_4.txt go_molecular_function_out_4.txt HG-U95
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_4.txt pathway_out_4.txt HG-U95
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_4.txt alignments_out_4.txt HG-U95
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_4.txt interpro_out_4.txt HG-U95

################################################################

# Generate for third type of array

perl Affy_HG_DataSeparator.pl HG_U95D.annot.csv 5 HG-U95
perl ../Affy_RemoveComments.pl  HG_U95D.annot.csv HG_U95D.annot_out.csv HG-U95

echo "Generating SQL Loader specific input data from Affy HT HG U95D MicroArray data"
perl Affy_HG_DataFormatter.pl representative_public_ID_file_out_5.txt representative_public_ID_out_5.txt representative_public_ID_out_5.log  HG-U95
perl Affy_HG_DataFormatter.pl unigene_ID_file_out_5.txt unigene_ID_out_5.txt unigene_ID_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl gene_title_file_out_5.txt gene_title_out_5.txt gene_title_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl gene_symbol_file_out_5.txt gene_symbol_out_5.txt gene_symbol_out_5.log HG-U95

perl Affy_HG_ChromosomeLocation_DataFormatter.pl chromosomal_location_file_out_5.txt chromosomal_location_out_5.txt HG-U95

perl Affy_HG_DataFormatter.pl entrez_gene_file_out_5.txt entrez_gene_out_5.txt entrez_gene_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl swissprot_file_out_5.txt swissprot_out_5.txt swissprot_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl OMIM_file_out_5.txt OMIM_out_5.txt OMIM_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_protein_id_file_out_5.txt refseq_protein_id_out_5.txt refseq_protein_id_out_5.log HG-U95
perl Affy_HG_DataFormatter.pl refseq_transcript_id_file_out_5.txt refseq_transcript_id_out_5.txt refseq_transcript_id_out_5.log HG-U95

perl Affy_HG_GoBiologicalProcess_DataFormatter.pl go_biological_process_file_out_5.txt go_biological_process_out_5.txt HG-U95
perl Affy_HG_GoCellularComponent_DataFormatter.pl go_cellular_component_file_out_5.txt go_cellular_component_out_5.txt HG-U95
perl Affy_HG_GoMolecularFunction_DataFormatter.pl go_molecular_function_file_out_5.txt go_molecular_function_out_5.txt HG-U95
perl Affy_HG_Pathway_DataFormatter.pl pathway_file_out_5.txt pathway_out_5.txt HG-U95
perl Affy_HG_Alignments_DataFormatter.pl alignments_file_out_5.txt alignments_out_5.txt HG-U95
perl Affy_HG_Interpro_DataFormatter.pl interpro_file_out_5.txt interpro_out_5.txt HG-U95

echo "Finished generating SQL Loader input files for Affymetrix HG_U95  MicroArray Data"
