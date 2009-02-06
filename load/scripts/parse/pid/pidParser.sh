#!/bin/sh

echo "Generate Interaction Molecule and Pathway files for Reactome \n"
perl splitXML.pl Reactome Reactome.xml

echo "Generate Interaction Molecule and Pathway files for NCI-Nature \n"
perl splitXML.pl NCI_Nature NCI-Nature_Curated.xml

echo "Generate Interaction Molecule and Pathway files for BioCarta \n"
perl splitXML.pl BioCarta BioCarta.xml

perl MoleculeParser.pl NCI_Nature Molecules.xml
perl InteractionParser.pl NCI_Nature Interactions.xml
perl PathwayParser.pl NCI_Nature Pathways.xml


perl MoleculeParser.pl BioCarta Molecules.xml
perl InteractionParser.pl BioCarta Interactions.xml
perl PathwayParser.pl BioCarta Pathways.xml


perl MoleculeParser.pl Reactome Molecules.xml
perl InteractionParser.pl Reactome Interactions.xml
perl PathwayParser.pl Reactome Pathways.xml
