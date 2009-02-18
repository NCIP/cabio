caBIO FreestyleLM Indexing
--------------------------

This distribution allows for generation of multiple sets of indexes, one set
for every version of caBIO in production. The steps to follow are as follows:

1) Configure build.properties
    a) Pick an empty (or non-existent) output directory for "index_location". 
    b) Configure the target database.
2) Type "ant" to run all 3 index generations. The generator will automatically
   create directories under your "index_location", called "[version]/indexes".
3) Monitor output under ./build/*/log/output.log
4) If the build is successful, check the ./log directory for the final logs.
   Verify that there were no errors during the run.
5) Run zip or tar on the output directories at "index_location" and move the 
   archives to the caBIO server for deployment.  
