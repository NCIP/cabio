Description
-----------
The unigeneparser downloads and parses the Unigene datafiles (containing 
data for loading the Gene, Clone, and NucleicAcidSequence ).

It also potentially does some data loading, if values are missing, 
although it is hard to tell if that code is ever called. 

TODO: Determine if Java code needs to update the database and remove
	  the dead code if necessary.

Running
-------
This program is run automatically by the caBIO loading scripts. The main 
script is scripts/parseAll.sh, which calls all the others. This script takes 
as parameters the JDBC database connection information. 

For example, to load qa31:

parseAll.sh jdbc:oracle:thin:@cbiodb30.nci.nih.gov:1521:CBTEST cabioqa31 dev!234
