#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/pid
mkpath.pl $CABIO_DATA_DIR/pid/Reactome
mkpath.pl $CABIO_DATA_DIR/pid/BioCarta
mkpath.pl $CABIO_DATA_DIR/pid/NCI_Nature

cd $CABIO_DATA_DIR/pid/Reactome
rm -rf *
wget -nv ftp://ftp1.nci.nih.gov/pub/PID/XML/Reactome.xml.gz
gunzip *.gz

cd $CABIO_DATA_DIR/pid/NCI_Nature
rm -rf *
wget -nv ftp://ftp1.nci.nih.gov/pub/PID/XML/NCI-Nature_Curated.xml.gz
gunzip *.gz

cd $CABIO_DATA_DIR/pid/BioCarta
rm -rf *
wget -nv ftp://ftp1.nci.nih.gov/pub/PID/XML/BioCarta.xml.gz
gunzip *.gz

