#!/bin/sh

echo "\nParsing Human MRNA data"
sh readmRNAHs.sh $1 $2 $3 

echo "Parsing Mouse MRNA data"
sh readmRNAMm.sh  $1 $2 $3
echo `wc -l *.LOG`
echo `wc -l *.BAD`

echo "\nParsing Human EST data"
sh readESTHs.sh $1 $2 $3

echo "Parsing Mouse EST data"
sh readESTMm.sh $1 $2 $3
echo `wc -l *.LOG`
echo `wc -l *.BAD`
