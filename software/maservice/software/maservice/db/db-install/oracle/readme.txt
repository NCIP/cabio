(1)edit kettle.properties to set properties. the property code base is a directory where all .ktr and .kjb files reside.
(2)copy file kettle.properties to C:\Documents and Settings\[user_name]\.kettle
(3)set java class path to point to ojdbc14.jar and the directory where ReadDBSNP.class resides.
(4)start up PDI with the option "No Repository"
(5)from File->Import from an XML file, open the file ma_job.kjb, click the button "run this job"
