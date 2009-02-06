#!/bin/sh
echo "EST_Annotations_Human_UCSC Data"
cd $CABIO_32_DATA_DIR/relative_clone/human
wc -l chr*

echo "EST_Annotations_Mouse_UCSC Data"
cd $CABIO_32_DATA_DIR/relative_clone/mouse
wc -l chr*

echo "MRNA_Annotations_Human_UCSC Data"
cd $CABIO_32_DATA_DIR/relative_clone/human
wc -l all_mrna.txt

echo "MRNA_Annotations_Mouse_UCSC Data"
cd $CABIO_32_DATA_DIR/relative_clone/mouse
wc -l all_mrna.txt 

echo "Cyband_Annotations_Human_UCSC Data"
cd $CABIO_32_DATA_DIR/cytoband/human
wc -l *

echo "Cyband_Annotations_Mouse_UCSC Data"
cd $CABIO_32_DATA_DIR/cytoband/mouse
wc -l *

echo "SNP_Annotations_TSC Data"
cd $CABIO_32_DATA_DIR/TSC_SNP
wc -l *

echo "Unigene_Annotations_CGAP Data"
cd $CABIO_32_DATA_DIR/ncbi_unigene
var1="Hs.data"; count1=`egrep -c "^ID          " Hs.data` 
var2="Mm.data"; count2=`egrep -c "^ID        " Mm.data` 
w1="$var1 $count1"
w2="$var2 $count2"
echo $w1
echo $w2

echo "EntrezGene_OMIM_GI_Unigene_mapping_NCBI Data"
cd $CABIO_32_DATA_DIR/unigene2gene
wc -l *

echo "SNP_Annotations_NCBI Data"
cd $CABIO_32_DATA_DIR/NCBI_SNP
for i in `ls $CABIO_32_DATA_DIR/NCBI_SNP`
do
count=`egrep -c "^rs" $i`
count1="$count $i"
echo $count1
done

echo "Swissprot_Annotations_UNIPROT Data"
cd $CABIO_32_DATA_DIR/protein
count=`egrep -c "^ID  " uniprot_sprot.dat`
count1="$count uniprot_sprot.dat"
echo $count1

# Remove leading and trailing whitespaces
# Remove colons
# Add colon as a delimiter  
cd $CABIO_32_DIR/scripts/reportGenerator
sed 's/^[ \t]*//;s/ *$//;s/ /:/;' $stats_LOG > log1.txt

# Extract first column (counts)
# Extract second column (data source name/ file name)
cut -d : -f 2 log1.txt > col1.txt
cut -d : -f 1 log1.txt > col2.txt

# Add in reverse order into log1.txt
paste col1.txt col2.txt > log1.txt

# Copy that as dataSources.log
cp log1.txt dataSources.log

# remove the unnecessary files
rm col1.txt col2.txt
rm log1.txt

# combine dataSources.log with old_dataSources.log into download data sources update
paste old_dataSources.log dataSources.log > download_data_sources_update.txt 

# Store dataSources.log as old_dataSources.log 
mv dataSources.log old_dataSources.log
