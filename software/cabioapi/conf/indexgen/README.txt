HOW TO GENERATE INDICES FOR CABIO

1. The indexgen.zip file is generated as part of the cabio build process.
2. Unzip the indexgen.zip file to a directory.
3. Update the searchapiconfig.properties file located in the indexGenerator/conf to point to the correct database and index locations.
4. Execute the ant runindex task from the indexGenerator directory.
