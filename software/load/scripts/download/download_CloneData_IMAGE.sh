#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/image_clone
cd $CABIO_DATA_DIR/image_clone
echo "Removing files from $CABIO_DATA_DIR/image_clone"
# rm -rf *

echo "Downloading the IMAGE clone data"
wget -nv ftp://image.llnl.gov/image/outgoing/arrayed_plate_data/cumulative/cumu*

echo "Unzipping downloaded files"
gunzip *.gz

echo "Finished downloading clone data from IMAGE"
