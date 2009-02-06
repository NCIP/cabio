#!/bin/sh
echo "Calling NCBI SNP data (dbSNP data) NCBI_Snp_DataParser.pl"
echo "Parsing Chromosome 1 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch1.flat ds_flat_ch1.flat.out 1  
echo "Parsing Chromosome 2 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch2.flat ds_flat_ch2.flat.out 2  
echo "Parsing Chromosome 3 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch3.flat ds_flat_ch3.flat.out 3  
echo "Parsing Chromosome 4 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch4.flat ds_flat_ch4.flat.out 4  
echo "Parsing Chromosome 5 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch5.flat ds_flat_ch5.flat.out 5  
echo "Parsing Chromosome 6 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch6.flat ds_flat_ch6.flat.out 6  
echo "Parsing Chromosome 7 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch7.flat ds_flat_ch7.flat.out 7  
echo "Parsing Chromosome 8 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch8.flat ds_flat_ch8.flat.out 8  
echo "Parsing Chromosome 9 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch9.flat ds_flat_ch9.flat.out 9  
echo "Parsing Chromosome 10 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch10.flat ds_flat_ch10.flat.out 10  
echo "Parsing Chromosome 11 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch11.flat ds_flat_ch11.flat.out 11  
echo "Parsing Chromosome 12 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch12.flat ds_flat_ch12.flat.out 12  
echo "Parsing Chromosome 13 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch13.flat ds_flat_ch13.flat.out 13  
echo "Parsing Chromosome 14 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch14.flat ds_flat_ch14.flat.out 14  
echo "Parsing Chromosome 15 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch15.flat ds_flat_ch15.flat.out 15  
echo "Parsing Chromosome 16 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch16.flat ds_flat_ch16.flat.out 16  
echo "Parsing Chromosome 17 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch17.flat ds_flat_ch17.flat.out 17  
echo "Parsing Chromosome 18 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch18.flat ds_flat_ch18.flat.out 18  
echo "Parsing Chromosome 19 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch19.flat ds_flat_ch19.flat.out 19  
echo "Parsing Chromosome 20 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch20.flat ds_flat_ch20.flat.out 20  
echo "Parsing Chromosome 21 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch21.flat ds_flat_ch21.flat.out 21  
echo "Parsing Chromosome 22 NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_ch22.flat ds_flat_ch22.flat.out 22  
echo "Parsing Chromosome X NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_chX.flat ds_flat_chX.flat.out X  
echo "Parsing Chromosome Y NCBI SNP Data"
perl NCBI_Snp_DataParser.pl ds_flat_chY.flat ds_flat_chY.flat.out Y  
echo "Finished parsing NCBI SNP Data"
