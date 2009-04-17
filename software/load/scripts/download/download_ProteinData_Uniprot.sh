#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/protein
cd $CABIO_DATA_DIR/protein
echo "Removing files from $CABIO_DATA_DIR/protein"
# rm -rf *

echo "Downloading protein annotations data from Uniprot"
wget -nv ftp://ftp.uniprot.org/pub/databases/uniprot_datafiles_by_format/flatfile/uniprot_sprot.dat.gz
echo "Unzipping downloaded file"
gunzip -f uniprot_sprot.dat.gz
echo "Finished downloading Swissprot Annotations from Uniprot"
