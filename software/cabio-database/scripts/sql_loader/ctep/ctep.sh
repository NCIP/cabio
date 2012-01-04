#!bin/sh

# Drop tables on cmapload 
echo "Dropping CTEP Tables"
cd $CABIO_DIR/scripts/sql_loader/ctep

sqlplus cmap/qa!cmap1234@bioqa @ctep_drop.sql

# All this hooplah is needed since this schema is 9i and we are loading into 10g
# imp needs same character set as was used by exp

# Import tables to cmapload
cd $CABIO_DATA_DIR/ctep
echo "Importing CTEP data into CMAP"
imp cmap/qa!cmap1234@BIOQA file=cmapexp.dmp fromuser=cmap

# Load data into caBIO via DB link
cd $CABIO_DIR/scripts/sql_loader/ctep
echo "Loading CTEP data into CaBIO"
$ORACLE_HOME/bin/sqlplus $1 @ctep_load.sql
