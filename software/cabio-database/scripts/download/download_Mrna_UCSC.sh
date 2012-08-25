#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/relative_clone/human
cd $CABIO_DATA_DIR/relative_clone/human
echo "\nRemoving existing MRNA data from $CABIO_DATA_DIR/relative_clone/human" 
rm -rf all_mrna.*

echo "Downloading MRNA Annotations for human from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/all_mrna.txt.gz
echo "Unzipping downloaded file"
gunzip -f all_mrna.txt.gz 

mkpath.pl $CABIO_DATA_DIR/relative_clone/mouse
cd $CABIO_DATA_DIR/relative_clone/mouse
echo "\nRemoving existing MRNA data from $CABIO_DATA_DIR/relative_clone/mouse" 
rm -rf all_mrna.*

echo "Downloading MRNA Annotations for mouse from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/all_mrna.txt.gz
echo "Unzipping downloaded file"
gunzip -f all_mrna.txt.gz

echo "\nFinish downloading the human and mouse MRNA Annotations from UCSC"
