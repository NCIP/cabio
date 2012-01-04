#!/bin/sh

perl Affymetrix_HuMappingMA_DataParser.pl Mapping250K_Nsp.annot.csv HuMapping
perl Affymetrix_HuMappingMA_DataParser.pl Mapping250K_Sty.annot.csv  HuMapping
perl Affymetrix_HuMappingMA_DataParser.pl Mapping50K_Hind240.annot.csv  HuMapping
perl Affymetrix_HuMappingMA_DataParser.pl Mapping50K_Xba240.annot.csv  HuMapping
