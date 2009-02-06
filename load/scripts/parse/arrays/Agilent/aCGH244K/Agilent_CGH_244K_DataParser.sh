#!/bin/sh

echo "Calling Agilent CGH 244K MicroArray Data Agilent_CGH_244K_DataParser.pl"
perl Agilent_CGH_244K_DataParser.pl GeneList.txt
echo "Finished parsing Agilent CGH 244K MicroArray Data"