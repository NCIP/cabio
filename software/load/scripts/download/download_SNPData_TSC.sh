#!/bin/sh

mkpath.pl $CABIO_DATA_DIR/TSC_SNP
cd $CABIO_DATA_DIR/TSC_SNP
echo "Removing existing files from $CABIO_DATA_DIR/TSC_SNP"
rm -rf *

echo "Downloading the TSC SNP Annotations"
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom1_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom2_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom3_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom4_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom5_tabsep.txt.gz &
wait
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom6_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom7_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom8_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom9_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom10_tabsep.txt.gz &
wait
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom11_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom12_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom13_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom14_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom15_tabsep.txt.gz &
wait
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom16_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom17_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom18_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom19_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom20_tabsep.txt.gz &
wait
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom21_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chrom22_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chromX_tabsep.txt.gz &
wget -nv ftp://hapmap.org/tscsnp-data/snps/tabsep/snps_chromY_tabsep.txt.gz &
wait
echo "Unzipping downloaded files"
gunzip -f snps_chrom1_tabsep.txt.gz &
gunzip -f snps_chrom2_tabsep.txt.gz &
gunzip -f snps_chrom3_tabsep.txt.gz &
gunzip -f snps_chrom4_tabsep.txt.gz &
gunzip -f snps_chrom5_tabsep.txt.gz &
wait 
gunzip -f snps_chrom6_tabsep.txt.gz &
gunzip -f snps_chrom7_tabsep.txt.gz &
gunzip -f snps_chrom8_tabsep.txt.gz &
gunzip -f snps_chrom9_tabsep.txt.gz &
gunzip -f snps_chrom10_tabsep.txt.gz &
wait
gunzip -f snps_chrom11_tabsep.txt.gz &
gunzip -f snps_chrom12_tabsep.txt.gz &
gunzip -f snps_chrom13_tabsep.txt.gz &
gunzip -f snps_chrom14_tabsep.txt.gz &
gunzip -f snps_chrom15_tabsep.txt.gz &
wait
gunzip -f snps_chrom16_tabsep.txt.gz &
gunzip -f snps_chrom17_tabsep.txt.gz &
gunzip -f snps_chrom18_tabsep.txt.gz &
gunzip -f snps_chrom19_tabsep.txt.gz &
gunzip -f snps_chrom20_tabsep.txt.gz &
wait
gunzip -f snps_chrom21_tabsep.txt.gz &
gunzip -f snps_chrom22_tabsep.txt.gz &
gunzip -f snps_chromX_tabsep.txt.gz &
gunzip -f snps_chromY_tabsep.txt.gz &
wait
echo "Finished downloading TSC SNP Annotations"
