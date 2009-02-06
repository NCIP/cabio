#!/bin/sh

cd $CABIO_DATA_DIR/ncbi_unigene                                                              
echo "\nRemoving existing files from $CABIO_DATA_DIR/ncbi_unigene"
rm -rf *

echo "Downloading Human Unigene sequences"
wget -nv -O Hs.seq.all.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Homo_sapiens/Hs.seq.all.gz  
wget -nv -O Hs.data.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Homo_sapiens/Hs.data.gz  
echo "Unzipping downloaded file"
gunzip Hs.seq.all.gz 
gunzip Hs.data.gz 

echo "\nDownloading Mouse Unigene sequences"
wget -nv -O Mm.seq.all.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Mus_musculus/Mm.seq.all.gz
wget -nv -O Mm.data.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Mus_musculus/Mm.data.gz
echo "Unzipping downloaded file"
gunzip Mm.seq.all.gz
gunzip Mm.data.gz

echo "Finished downloading Human and Mouse Unigene sequences"
