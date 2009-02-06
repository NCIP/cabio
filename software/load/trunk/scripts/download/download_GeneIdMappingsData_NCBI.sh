#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/unigene2gene
cd $CABIO_DATA_DIR/unigene2gene

echo "Removing files from $CABIO_DATA_DIR/unigene2gene"
rm -rf *

echo "Downloading Accession numbers mapping (NCBI-Unigene, OMIM-Unigene, Gene-Accession)"
wget -nv ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2unigene
wget -nv ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/mim2gene
wget -nv ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene_refseq_uniprotkb_collab.gz  	 
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz  	 

gunzip -f gene2accession.gz
gunzip -f gene_info.gz
mv gene2unigene gene2unigene.txt
mv mim2gene mim2gene.txt
mv gene2accession gene2accession.txt

gunzip gene_refseq_uniprotkb_collab.gz
mv gene_refseq_uniprotkb_collab gene_refseq_uniprotkb_collab.txt 
