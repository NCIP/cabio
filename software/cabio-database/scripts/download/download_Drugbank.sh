#!/bin/sh
mkpath.pl $CABIO_DATA_DIR/drugbank || exit 1
cd $CABIO_DATA_DIR/drugbank || exit 1
rm drugcards.zip
mv drugcards.txt drugcards.txt.old
wget -nv http://www.drugbank.ca/public/downloads/current/drugcards.zip
unzip drugcards.zip
