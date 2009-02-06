#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/mergedSNPids
cd $CABIO_DATA_DIR/mergedSNPids
echo "Removing existing data files from $CABIO_DATA_DIR/mergedSNPids"
rm -rf *

echo "Downloading merged SNP Rs Ids from NCBI (dbSNP)"
wget -nv ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/database/organism_data/RsMergeArch.bcp.gz
gunzip RsMergeArch.bcp.gz

echo "Finished downloading merged SNP Rs Ids for dbSNP from NCBI"
