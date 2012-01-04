#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/cytoband/human
cd $CABIO_DATA_DIR/cytoband/human

echo "Removing existing files from $CABIO_DATA_DIR/cytoband/human"
rm -rf *

echo "\nDownloading human cytoband annotations data from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/cytoBand.txt.gz
echo "Unzipping downloaded file"
gunzip -f cytoBand.txt.gz

mkpath.pl $CABIO_DATA_DIR/cytoband/mouse
cd $CABIO_DATA_DIR/cytoband/mouse

echo "\nRemoving existing files from $CABIO_DATA_DIR/cytoband/mouse"
rm -rf *

echo "Downloading mouse cytoband annotations data from UCSC"
wget -nv ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/cytoBand.txt.gz
echo "Unzipping downloaded file"
gunzip -f cytoBand.txt.gz
echo "\nFinished downloading human and mouse cytoband annotations from UCSC"
