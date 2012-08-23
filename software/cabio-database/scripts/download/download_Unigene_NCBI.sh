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
# move the empty lines for the Java parser to work
sed '/^$/d' Hs.data>Hs.data.trim
mv Hs.data.trim Hs.data

echo "\nDownloading Mouse Unigene sequences"
wget -nv -O Mm.seq.all.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Mus_musculus/Mm.seq.all.gz
wget -nv -O Mm.data.gz ftp://ftp.ncbi.nih.gov/repository/UniGene/Mus_musculus/Mm.data.gz
echo "Unzipping downloaded file"
gunzip Mm.seq.all.gz
gunzip Mm.data.gz
# move the empty lines for the Java parser to work
sed '/^$/d' Mm.data>Mm.data.trim
mv Mm.data.trim Mm.data

echo "Finished downloading Human and Mouse Unigene sequences"
