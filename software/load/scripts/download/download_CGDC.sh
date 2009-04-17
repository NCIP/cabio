#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/cgdc
cd $CABIO_DATA_DIR/cgdc
# rm * 
wget -nv ftp://ftp1.nci.nih.gov/pub/cacore/Cancer%20Gene%20Data%20Curation/Cancer_Gene_DB_p21.xml
wget -nv ftp://ftp1.nci.nih.gov/pub/cacore/Cancer%20Gene%20Data%20Curation/Cancer_Gene_DB_p22.xml
wget -nv ftp://ftp1.nci.nih.gov/pub/cacore/Cancer%20Gene%20Data%20Curation/Gene_Drug_DB_p21.xml
wget -nv ftp://ftp1.nci.nih.gov/pub/cacore/Cancer%20Gene%20Data%20Curation/Gene_Drug_DB_p22.xml
wget -nv http://ctep.cancer.gov/forms/agents.txt 

