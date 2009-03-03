#!/usr/bin/sh
cd ~/cabio_data/cgdc

# Add all compounds from v1 to combined

sed -e "s/<\/GeneEntryCollection>//g" v1/NCI_all_compound.xml > combined.xml

# Add all diseases from v1 to combined

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"CancerIndex_disease_XML\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" v1/NCI_all_disease.xml >> combined.xml

# Add all compounds from v2 to combined

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"deliverable\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" v2/Cancer_Gene_DB_p21.xml >> combined.xml

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"deliverable\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" v2/Cancer_Gene_DB_p22.xml >> combined.xml

# Add all diseases from v2 to combined

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"deliverable\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" v2/Gene_Drug_DB_p21.xml >> combined.xml

sed -e "s/<GeneEntryCollection>//g;s/<\/GeneEntryCollection>//g;s/<\!DOCTYPE GeneEntryCollection SYSTEM \"deliverable\.dtd\">//g;s/<?xml version=\"1.0\"?>//g" v2/Gene_Drug_DB_p22.xml >> combined.xml


echo "</GeneEntryCollection>" >> combined.xml


