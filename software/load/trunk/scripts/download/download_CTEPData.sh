#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/ctep
cd $CABIO_DATA_DIR/ctep

echo "Removing files from $CABIO_DATA_DIR/ctep"
rm -rf *

echo "Downloading CTEP data from ftp://ftpctep.nci.nih.gov/cmapexp.dmp"
wget -nv --ftp-user=ncicb --ftp-pass=ncicb_428 ftp://ftpctep.nci.nih.gov/cmapexp.dmp

echo "Finished downloading CTEP data"
