#!/bin/sh 
mkpath.pl $CABIO_DATA_DIR/temp/relative_clone 
java -classpath ".:../build:../lib/ojdbc14.jar:../lib/commons-net-1.4.0.jar" gov.nih.nci.caBIO.dataload.ParseAllmrna $CABIO_DATA_DIR/relative_clone/mouse/all_est.txt $CABIO_DATA_DIR/temp/relative_clone/all_est_mouse_stage.dat $1 $2 $3 &
wait
