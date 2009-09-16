#!/bin/sh
cd $CABIO_DIR/scripts
time nohup sh load_g.sh $SCHEMA/$SCHEMA_PWD@$SCHEMA_DB 1> results_cabiodev.log 2>&1 &
#time nohup sh $LOAD/scripts_load.sh $SCHEMA\/$SCHEMA_PWD\@$SCHEMA_DB 1>>$sqlldr_LOG 2>$sqlldr_BAD &

