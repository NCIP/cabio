Description
-----------
The unigeneparser parses the Unigene datafiles (containing 
data for loading the Gene, Clone, and NucleicAcidSequence ).

Running
-------
This program is run automatically by the caBIO loading scripts. The main 
script is scripts/parseAll.sh, which calls all the others. This script takes 
as parameters the JDBC database connection information. 

For example, to load qa31:

parseAll.sh jdbc:oracle:thin:@cbiodb30.nci.nih.gov:1521:CBTEST cabioqa31 
