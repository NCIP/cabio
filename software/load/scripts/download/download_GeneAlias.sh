#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/unigene2gene
cd $CABIO_DATA_DIR/unigene2gene
# rm gene_info.txt
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz

gunzip gene_info.gz
mv gene_info gene_info.txt
