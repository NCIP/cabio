#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/relative_clone/human
cd $CABIO_DATA_DIR/relative_clone/human
echo "Removing existing files from $CABIO_DATA_DIR/relative_clone/human"
rm -rf *

echo "\nDownloading EST Annotations for human from UCSC"
wget -nv http://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr1_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr2_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr3_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr4_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr5_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr6_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr7_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr8_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr9_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr10_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr11_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr12_est.txt.gz
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr13_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr14_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr15_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr16_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr17_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr18_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr19_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr20_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr21_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chr22_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chrX_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/database/chrY_est.txt.gz 
#wget -nv ftp://ftp.ncbi.nih.gov/genomes/MapView/Homo_sapiens/sequence/current/initial_release/seq_gene.md.gz
wget -nv ftp://ftp.ncbi.nih.gov/genomes/MapView/Homo_sapiens/sequence/BUILD.36.3/initial_release/seq_gene.md.gz 
echo "Unzipping downloaded files"
gunzip -f chr1_est.txt.gz &
gunzip -f chr2_est.txt.gz &
gunzip -f chr3_est.txt.gz &
gunzip -f chr4_est.txt.gz &
gunzip -f chr5_est.txt.gz &
wait
gunzip -f chr6_est.txt.gz &
gunzip -f chr7_est.txt.gz &
gunzip -f chr8_est.txt.gz &
gunzip -f chr9_est.txt.gz &
gunzip -f chr10_est.txt.gz &
wait
gunzip -f chr11_est.txt.gz &
gunzip -f chr12_est.txt.gz &
gunzip -f chr13_est.txt.gz &
gunzip -f chr14_est.txt.gz &
gunzip -f chr15_est.txt.gz &
wait
gunzip -f chr16_est.txt.gz &
gunzip -f chr17_est.txt.gz &
gunzip -f chr18_est.txt.gz &
gunzip -f chr19_est.txt.gz &
gunzip -f chr20_est.txt.gz &
wait
gunzip -f chr21_est.txt.gz &
gunzip -f chr22_est.txt.gz &
gunzip -f chrX_est.txt.gz &
gunzip -f chrY_est.txt.gz &
gunzip -f seq_gene.md.gz
wait

mkpath.pl $CABIO_DATA_DIR/relative_clone/mouse
cd $CABIO_DATA_DIR/relative_clone/mouse
echo "\nRemoving existing files from $CABIO_DATA_DIR/relative_clone/mouse"		
rm -rf *

echo "Downloading EST Annotations for mouse from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr1_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr2_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr3_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr4_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr5_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr6_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr7_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr8_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr9_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr10_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr11_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr12_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr13_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr14_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr15_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr16_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr17_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr18_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chr19_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chrX_est.txt.gz 
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/chrY_est.txt.gz 
wget -nv ftp://ftp.ncbi.nih.gov/genomes/MapView/Mus_musculus/sequence/current/initial_release/seq_gene.md.gz &
echo "Unzipping downloaded files"
gunzip -f chr1_est.txt.gz &
gunzip -f chr2_est.txt.gz &
gunzip -f chr3_est.txt.gz & 
gunzip -f chr4_est.txt.gz &
gunzip -f chr5_est.txt.gz &
wait
gunzip -f chr6_est.txt.gz &
gunzip -f chr7_est.txt.gz &
gunzip -f chr8_est.txt.gz &
gunzip -f chr9_est.txt.gz &
gunzip -f chr10_est.txt.gz &
gunzip -f chr11_est.txt.gz
wait
gunzip -f chr12_est.txt.gz &
gunzip -f chr13_est.txt.gz &
gunzip -f chr14_est.txt.gz &
gunzip -f chr15_est.txt.gz &
gunzip -f chr16_est.txt.gz &
gunzip -f chr17_est.txt.gz &
wait
gunzip -f chr18_est.txt.gz &
gunzip -f chr19_est.txt.gz &
gunzip -f chrX_est.txt.gz &
gunzip -f chrY_est.txt.gz &
gunzip -f seq_gene.md.gz
echo "\nFinished downloading the human and mouse EST Annotations from UCSC"


