#!/bin/sh
mkpath.pl $CABIO_DATA_DIR/arrays/Illumina/GoldenGateMethylation
cd $CABIO_DATA_DIR/arrays/Illumina/GoldenGateMethylation

wget -nv http://www.illumina.com/downloads/CancerPanelFiles.zip

mkpath.pl $CABIO_DATA_DIR/arrays/Illumina/HumanHap550K
cd $CABIO_DATA_DIR/arrays/Illumina/HumanHap550K

wget -nv ftp://Guest:illumina@ftp.illumina.com/Whole%20Genome%20Genotyping%20Files/HumanHap550_v3_product_files/Annotation/HumanHap550v3_Gene_Annotation.zip


#mkpath.pl $CABIO_DATA_DIR/arrays/Agilent/aCGH244K
#cd $CABIO_DATA_DIR/arrays/Agilent/aCGH244K

#wget -nv http://www.chem.agilent.com/cag/bsp/oligoGL/014693_D_GeneList_20070207.txt.zip


#mkpath.pl $CABIO_DATA_DIR/arrays/Agilent/HumanGenome44K
#cd $CABIO_DATA_DIR/arrays/Agilent/HumanGenome44K
#wget -nv http://www.chem.agilent.com/cag/bsp/oligoGL/012391_D_AA_20070207.txt.zip
