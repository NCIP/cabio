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
#wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz  	 
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene2refseq.gz  	 
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene2go.gz  	 
wget -nv ftp://ftp.ncbi.nih.gov/gene/DATA/gene2pubmed.gz  	 

wget -nv ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz
wget -nv ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Mus_musculus.gene_info.gz
 

gunzip -f gene2accession.gz
#gunzip -f gene_info.gz
gunzip -f gene2refseq.gz
gunzip -f gene2go.gz
gunzip -f gene2pubmed.gz
gunzip gene_refseq_uniprotkb_collab.gz
gunzip Homo_sapiens.gene_info.gz
gunzip Mus_musculus.gene_info.gz

mv gene2unigene gene2unigene.txt
mv mim2gene mim2gene.txt
mv gene2accession gene2accession.txt
mv gene2refseq gene2refseq.txt
mv gene2go gene2go.txt
mv gene2pubmed gene2pubmed.txt
mv gene_refseq_uniprotkb_collab gene_refseq_uniprotkb_collab.txt

sed -i "s/\t/**/g" Homo_sapiens.gene_info  
sed -i "s/\t/**/g" Mus_musculus.gene_info  


mkpath.pl $CABIO_DATA_DIR/refseq
cd $CABIO_DATA_DIR/refseq

echo "Removing files from $CABIO_DATA_DIR/refseq"
rm -rf *

wget -nv ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/mRNA_Prot/human.rna.fna.gz
wget -nv ftp://ftp.ncbi.nlm.nih.gov/refseq/M_musculus/mRNA_Prot/mouse.rna.fna.gz

gunzip mouse.rna.fna.gz
gunzip human.rna.fna.gz

#sed -e -i '/^gi/ s/\$/|5|/g' human.rna.fna
#awk '{if(substr($0,length)=="|")print "\n",$0; else printf("%s",$0);}' human.rna.fna.1

