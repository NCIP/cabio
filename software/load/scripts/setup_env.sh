#!/bin/sh
export CABIO_DIR=/data1/src/trunk/cabio-db-automation/load
export CABIO_DATA_DIR=/cabio/cabiodb/cabio_data
export GRIDID_PATH=/data1/src/trunk/cabio-db-automation/load/gridid
export LOAD=/data1/src/trunk/cabio-db-automation/load/scripts/sql_loader

# executables 
export PERL5LIB=$PERL5LIB:"$CABIO_DIR"/scripts/parse
export SQLLDR=/data/apps/oracle/product/db-10.2/bin/sqlldr
export SQLPLUS=/data/apps/oracle/product/db-10.2/bin/sqlplus
export PATH="$PATH":"$CABIO_DIR"/bin


# D/B Connection parameters
export CONNECT_STRING=jdbc:oracle:thin:@localhost:1521:CABIO1
export DBI_DRIVER='DBI:Oracle:CABIO1'
export SCHEMA='cabiorefresh'
export SCHEMA_PWD='cabiorefresh'
export SCHEMA_DB='CABIO1'

export dt=`date '+%m_%d_%y'`

# Log files

export download_LOG=DOWNLOAD.$dt.log
export download_BAD=DOWNLOAD.$dt.bad
export parse_LOG=PARSE.$dt.log
export parse_BAD=PARSE.$dt.bad
export stat_LOG=STATS.$dt.log
export stat_BAD=STATS.$dt.bad
export sqlldr_LOG=SQLLDR.$dt.log
export sqlldr_BAD=SQLLDR.$dt.bad
export grididload_LOG=GRIDIDLOAD.$dt.log
export grididload_BAD=GRIDIDLOAD.$dt.bad
chmod +x "$CABIO_DIR"/bin/mkpath.pl
