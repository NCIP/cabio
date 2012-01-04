#!/usr/bin/sh
cd ~/cabio_data/cgdc

# Add all compounds from v1 to combined

sed -e "s/<\/GeneEntryCollection>//g" NCI_CancerIndex_allphases_compound.xml > combined.xml

# Add all diseases from v1 to combined

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"CancerIndex_disease_XML\.dtd\">//g;s/<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>//g" NCI_CancerIndex_allphases_disease.xml >> combined.xml


echo "</GeneEntryCollection>" >> combined.xml


