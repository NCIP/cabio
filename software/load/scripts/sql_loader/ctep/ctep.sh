#!bin/sh

# Drop tables on cmapload 
echo "Dropping CTEP Tables"
cd $CABIO_DIR/scripts/sql_loader/ctep
echo $ORACLE_HOME 

$ORACLE_HOME/bin/sqlplus cmap/qa\!cmap1234@CBTEST @ctep_drop.sql

# All this hooplah is needed since this schema is 9i and we are loading into 10g
# imp needs same character set as was used by exp

export ORACLE_HOME=/app/oracle/product/9iClient
export SQLLDR=/app/oracle/product/9iClient/bin/sqlldr
export SQLPLUS=/app/oracle/product/9iClient/bin/sqlplus

# Import tables to cmapload
cd $CABIO_DATA_DIR/ctep
echo "Importing CTEP data into CMAP"
/app/oracle/product/9iClient/bin/imp cmap/qa\!cmap1234@CBTEST file=cmapexp.dmp fromuser=cmap

# Revert to normalcy 
export ORACLE_HOME=/app/oracle/product/10gClient
export SQLLDR=/app/oracle/product/10gClient/bin/sqlldr
export SQLPLUS=/app/oracle/product/10gClient/bin/sqlplus


# Load data into caBIO via DB link
cd $CABIO_DIR/scripts/sql_loader/ctep
echo "Loading CTEP data into CaBIO"
$ORACLE_HOME/bin/sqlplus $1 @ctep_load.sql
