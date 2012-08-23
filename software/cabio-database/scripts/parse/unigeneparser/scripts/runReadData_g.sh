#!/bin/sh

echo "Parsing Unigene Data (Hs.data and Mm.data)"
mkpath.pl $CABIO_DATA_DIR/ncbi_unigene
java -Xmx3072M -classpath .:../lib/ojdbc14.jar:../build gov.nih.nci.caBIO.dataload.ReadFile $CABIO_DATA_DIR/ncbi_unigene $1 $2 $3
