#!/bin/sh
#ORACLE_HOME=/app/oracle/product/10gClient
#export ORACLE_HOME
echo "Parsing the NCBI-SNP, Uniprot-Protein and IMAGE-Clone data"
cd "$CABIO_DIR"/scripts/parse/snp
rm *.log  
rm *.bad 
sh NCBI_Snp_DataParser.sh 
echo `ls -a *.log`
count=`egrep -c "^rs" NCBI_SNP_parser.bad`
count1="$count NCBI_SNP_parser.bad"
echo $count1

echo "Parsing the Uniprot protein data"
cd "$CABIO_DIR"/scripts/parse/protein
rm *.log  
rm *.bad 
sh Uniprot_Protein_DataParser.sh 
echo `ls -a *.log`
count=`egrep -c "^ID  " UNIPROT_parser.bad`
count1="$count UNIPROT_parser.bad"
echo $count1

echo "Parsing the clone data from IMAGE"
cd "$CABIO_DIR"/scripts/parse/image_clone
rm *.log  
rm *.bad  
sh IMAGE_Clone_DataParser.sh 
echo `ls -a *.log`
echo `wc -l *.bad` 

echo "Parsing the human and mouse cytoband data from UCSC"
cd "$CABIO_DIR"/scripts/parse/cytoband
rm *.log  
rm *.bad  
sh UCSC_Cytoband_DataParser.sh 
echo `ls -a *.log`
echo `wc -l *.bad` 

echo "Parsing the UniSTS Marker Aliases"
cd "$CABIO_DIR"/scripts/parse/marker
rm *.log  
rm *.bad  
perl markerAlias.pl UniSTS.aliases
perl markerParse.pl UniSTS.sts
echo `ls -a *.log`
echo `wc -l *.bad` 

echo "Parsing the Gene Aliases"
cd "$CABIO_DIR"/scripts/parse/geneAlias
rm *.log  
rm *.bad  
sh geneAliasParser.sh

echo "\nParsing EST, MRNA and Unigene Data"
cd $CABIO_DIR/scripts/parse/unigeneparser/scripts
rm *.log  
rm *.bad  
sh parseAll.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD 
echo `ls -a *.log`
echo `wc -l *.bad` 

echo "\nParsing  Pathway data"
cd $CABIO_DIR/scripts/parse/pid 
rm *.log
rm *.bad
sh pidParser.sh   
echo `ls -a *.log`
echo `wc -l *.bad` 

wait
echo "Finished parsing NCBI SNP, Uniprot, Unigene, EST, MRNA, Cytoband, Pathway and Image Clone Data"
