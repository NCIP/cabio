#!/bin/sh

echo "Parsing Microarray annotations data"
cd "$CABIO_DIR"/scripts/parse/arrays
perl processFileNames.pl

echo "Parsing Affymetrix HG-U133_Plus2 MicroArray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HG-U133_Plus2
sh Affymetrix_HG_U133_Plus2_DataParser.sh

echo "Parsing Affymetrix HG-U133A MicroArray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HG-U133
sh Affymetrix_HG_U133_DataParser.sh

echo "Parsing Affymetrix HuMapping MicroArray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HuMapping
sh Affymetrix_HuMappingMA_DataParser.sh

echo "Parsing Affymetrix HG-U95 Microarray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HG-U95-U133B-6800
sh Affy_HGU95_DataParser.sh

echo "Parsing Affymetrix HG-U133B Microarray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HG-U95-U133B-6800
sh Affy_HGU133B_DataParser.sh

echo "Parsing Affymetrix Hu6800 Microarray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HG-U95-U133B-6800
sh Affy_Hu6800_DataParser.sh

echo "Parsing Agilent aCGH data"
cd "$CABIO_DIR"/scripts/parse/arrays/Agilent/aCGH244K
sh Agilent_CGH_244K_DataParser.sh 

echo "Parsing Agilent Human Genome 44K data"
cd "$CABIO_DIR"/scripts/parse/arrays/Agilent/HumanGenome44K
sh Agilent_HumanGenome44K_DataParser.sh

echo "Parsing Affymetrix HuEx10ST Microarray data"
cd "$CABIO_DIR"/scripts/parse/arrays/Affymetrix/HuEx10ST
sh exon_parser.sh

echo "Finished parsing MicroArray Data"
