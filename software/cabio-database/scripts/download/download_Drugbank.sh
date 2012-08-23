#!/bin/sh
mkpath.pl $CABIO_DATA_DIR/drugbank || exit 1
cd $CABIO_DATA_DIR/drugbank || exit 1
rm drugcards.zip
mv drugcards.txt drugcards.txt.old
# please note this version of the drug card doesn't contain the latest drug bank data
# TODO: retrieve the latest XML format and rewrite the parser
wget -nv http://www.drugbank.ca/system/downloads/2.5/drugcards.zip
unzip drugcards.zip
