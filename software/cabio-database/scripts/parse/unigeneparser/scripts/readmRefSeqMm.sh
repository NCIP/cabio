#!/bin/sh
java -classpath ".:../build:../lib/ojdbc14.jar:../lib/commons-net-1.4.0.jar" gov.nih.nci.caBIO.dataload.ReadRefSeqSequences $CABIO_DATA_DIR/refseq/ mouse.rna.fna  mm_refseq.dat