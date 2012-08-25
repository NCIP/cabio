#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/marker

cd $CABIO_DATA_DIR/marker/human
rm -rf UniSTS_human.sts
rm -rf seq_sts.md
 
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS_human.sts
#wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/mapview/seq_sts.md.gz
wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/MapView/Homo_sapiens/sequence/current/initial_release/seq_sts.md.gz 
#wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/ARCHIVE/BUILD.36.3/mapview/seq_sts.md.gz
gunzip *.gz

cd $CABIO_DATA_DIR/marker/mouse
rm -rf UniSTS_mouse.sts
rm -rf seq_sts.md

wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS_mouse.sts
#wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/M_musculus/mapview/seq_sts.md.gz
wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/MapView/Mus_musculus/sequence/current/initial_release/seq_sts.md.gz
gunzip *.gz

cd $CABIO_DATA_DIR/marker
rm UniSTS.* 
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS.aliases
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS.sts
