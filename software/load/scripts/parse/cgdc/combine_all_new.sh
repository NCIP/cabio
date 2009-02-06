#!/usr/bin/sh
cd ~/cabio_data/cgdc
sed -e "s/<\/GeneEntryCollection>//g" NCI_all_compound.xml > NCI_all_compound.xml.mod
sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"CancerIndex_disease_XML\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" NCI_all_disease.xml > NCI_all_disease.xml.mod
cat NCI_all_disease.xml.mod >> NCI_all_compound.xml.mod
echo "</GeneEntryCollection>" >> NCI_all_compound.xml.mod
