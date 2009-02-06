#!/bin/sh

echo "Calling Agilent Human Genome 44K MicroArray Data Agilent_HumanGenome_44K_DataParser.pl"
perl -p -i -e "s/\t/#/g" /cabio/cabiodb/cabio_data/arrays/Agilent/HumanGenome44K/012391_D_AA_20070207.txt
perl Agilent_HumanGenome44K_DataParser.pl 012391_D_AA_20070207.txt 
echo "Finished parsing Agilent Human Genome 44K MicroArray Data"
