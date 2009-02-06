LOAD DATA 

INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom1_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom2_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom3_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom4_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom5_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom6_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom7_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom8_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom9_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom10_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom11_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom12_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom13_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom14_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom15_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom16_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom17_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom18_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom19_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom20_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom21_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chrom22_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chromX_tabsep.txt'
INFILE '/cabio/cabiodb/cabio_data/TSC_SNP/snps_chromY_tabsep.txt'
 
APPEND
 
INTO TABLE SNP_TSC_RS 
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "	"
Trailing nullcols
 
(TSC_ID,
  SS_ID,
  DBSNP_RS_ID)
