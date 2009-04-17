#!/bin/sh
mkpath.pl $CABIO_DATA_DIR/NCBI_SNP
cd $CABIO_DATA_DIR/NCBI_SNP
wget -nv -N -r -np -nH ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/ASN1_flat/ -nd

echo "Unzipping downloaded files"
gunzip -f *.gz
