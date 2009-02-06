#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/marker

cd $CABIO_DATA_DIR/marker/human
rm -rf *
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS_human.sts
wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/mapview/seq_sts.md.gz
gunzip *

cd $CABIO_DATA_DIR/marker/mouse
rm -rf *
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS_mouse.sts
wget -nv ftp://ftp.ncbi.nlm.nih.gov/genomes/M_musculus/mapview/seq_sts.md.gz
gunzip *

cd $CABIO_DATA_DIR/marker
rm *
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS.aliases
wget -nv ftp://ftp.ncbi.nlm.nih.gov/repository/UniSTS/UniSTS.sts

