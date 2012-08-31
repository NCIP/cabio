#!/bin/sh
cd ..
echo "\nBuilding Java parser"
ant build
cd scripts

rm -rf *.log
rm -rf *.bad
rm $CABIO_DATA_DIR/ncbi_unigene/nas.dat

echo "\nParsing EST and MRNA Annotations for Human and Mouse"
sh readLocation.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD & 

echo "\nParsing Unigene Data for Human and Mouse from Unigene"
sh runReadData_g.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD &

echo "\nParsing Unigene Sequences for Human and Mouse from Unigene"
sh runseq_g.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD &
wait

cd $CABIO_DIR/scripts/parse/unigeneparser/scripts 
echo "\nGenerating NucleicAcidSequence Data from sequence.dat and nas.dat"
sh generateNas.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD 

sh generateCRL.sh $CONNECT_STRING $SCHEMA $SCHEMA_PWD 

sh readmRefSeqHs.sh
sh readmRefSeqMm.sh

# Generate clone_seq_end.dat
rm -rf $CABIO_DATA_DIR/ncbi_unigene/clone_seq_end.dat
perl clone_seq_end.pl

echo `ls *EST*.log`
echo `wc -l *EST*.bad`
echo `ls *MRNA*.log`
echo `wc -l *MRNA*.bad`
echo `ls UNIGENE_*.log`
echo `wc -l UNIGENE_*.bad`
wait
echo `ls NAS_*.log`
echo `wc -l NAS_*.bad`

exit;
