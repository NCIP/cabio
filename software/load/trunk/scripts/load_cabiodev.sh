#!/bin/sh
cd $CABIO_DIR/scripts
time nohup sh load_g.sh $SCHEMA/$SCHEMA_PWD@$SCHEMA_DB 1> results_cabiodev.log 2>&1 &
