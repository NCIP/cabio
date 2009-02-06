#!/bin/sh

# Configure enviroment variables
`source setup_env.sh`

echo "Starting load " | mail -s "Starting load " viswanathl@mail.nih.gov
# Download data
echo "Starting download"
cd $CABIO_DIR/scripts/download
rm *.log
rm *.bad
time sh Download_NonArray_Data.sh 1>$download_LOG 2>$download_BAD &

# Start off by loading the library stuff
# Library_ID is extarcted from LIBRARY table during parse of Unigene Data to generate data for CLONE_TV etc
# Hence this should happen before the Java parser is run

cd $CABIO_DIR/scripts/sql_loader
time sqlplus $SCHEMA\/$SCHEMA_PWD\@$SCHEMA_DB @$LOAD/all_ref_constraints.sql 1>refConstraints.log 2>&1
time sqlplus $SCHEMA\/$SCHEMA_PWD\@$SCHEMA_DB @$LOAD/constraints/disable.referential.sql 1>>refConstraints.log 2>&1
 
echo "Beginning PL/SQL procedures that load from CGAP (BIOPATHWAYS, LIBRARIES, etc)";
time sqlplus $SCHEMA\/$SCHEMA_PWD\@$SCHEMA_DB @$LOAD/sql/cgap_dataLoad.sql 1>cgapLoad.log 2>&1 &
wait

echo "Done download " | mail -s "Finished download and library-load " viswanathl@mail.nih.gov

# Parse data
echo "Starting parse of non-array data"
cd $CABIO_DIR/scripts/parse
rm *.log
rm *.bad
time sh Parse_NonMicroArray_Data.sh 1>$parse_LOG 2>$parse_BAD 

#Parse Array data
echo "Starting parse of array data"
cd $CABIO_DIR/scripts/parse
sh parse_MicroArray_Data.sh 1>>$parse_LOG 2>>$parse_BAD 

echo "Done Parse " | mail -s "Finished parse " viswanathl@mail.nih.gov

# Load Data
echo "Beginning Data Loads(array and non-array data) using SQL Loader and SQL"
cd $CABIO_DIR/scripts/sql_loader
rm *.log
rm *.bad

time sh scripts_load.sh $SCHEMA\/$SCHEMA_PWD\@$SCHEMA_DB 1>>$sqlldr_LOG 2>$sqlldr_BAD  

echo "Done Part 4 " | mail -s "Finished data load " viswanathl@mail.nih.gov
exit
