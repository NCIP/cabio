#!/bin/sh

#echo "\nParsing Human Unigene Sequences"
cd $CABIO_DIR/scripts/parse/unigeneparser/scripts
java -Xmx3072M -XX:+UseParallelGC -Xmn3072M -XX:+UseAdaptiveSizePolicy -classpath .:../lib/ojdbc14.jar:../lib/commons-net-1.4.0.jar:../build gov.nih.nci.caBIO.dataload.ReadSequences "$CABIO_DATA_DIR"/ncbi_unigene Hs.seq.all $1 $2 $3
echo "\nParsing Mouse Unigene Sequences"
java -Xmx3072M -XX:+UseParallelGC -Xmn3072M -XX:+UseAdaptiveSizePolicy -classpath .:../lib/ojdbc14.jar:../lib/commons-net-1.4.0.jar:../build gov.nih.nci.caBIO.dataload.ReadSequences "$CABIO_DATA_DIR"/ncbi_unigene Mm.seq.all $1 $2 $3
