#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/relative_clone/human
cd $CABIO_DATA_DIR/relative_clone/human
echo "Removing existing files from $CABIO_DATA_DIR/relative_clone/human"
rm -rf *

echo "\nDownloading EST Annotations for human from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/all_est.txt.gz 
#wget -nv ftp://ftp.ncbi.nih.gov/genomes/MapView/Homo_sapiens/sequence/BUILD.37.1/initial_release/seq_gene.md.gz 
wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/MapView/Homo_sapiens/sequence/current/initial_release/seq_gene.md.gz 
echo "Unzipping downloaded files"
gunzip -f all_est.txt.gz &
gunzip -f seq_gene.md.gz
wait

mkpath.pl $CABIO_DATA_DIR/relative_clone/mouse
cd $CABIO_DATA_DIR/relative_clone/mouse
echo "\nRemoving existing files from $CABIO_DATA_DIR/relative_clone/mouse"		
rm -rf *

echo "Downloading EST Annotations for mouse from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/all_est.txt.gz 
wget -nv ftp://ftp.ncbi.nih.gov/genomes/MapView/Mus_musculus/sequence/current/initial_release/seq_gene.md.gz &

gunzip -f all_est.txt.gz &
gunzip -f seq_gene.md.gz
echo "\nFinished downloading the human and mouse EST Annotations from UCSC"


