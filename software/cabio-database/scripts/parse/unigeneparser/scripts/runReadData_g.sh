#!/bin/sh

echo "Downloading and parsing Unigene Data (Hs.data and Mm.data) from CGAP"
mkpath.pl $CABIO_DATA_DIR/ncbi_unigene
java -Xmx3072M -classpath .:../lib/commons-net-1.4.0.jar:../lib/ojdbc14.jar:../build gov.nih.nci.caBIO.dataload.ReadFile /cgap_data/ ncicbftp2.nci.nih.gov cgapftp cg@p+tp $CABIO_DATA_DIR/ncbi_unigene $1 $2 $3
