#!/bin/sh
cd $CABIO_DIR/scripts
nohup sh load_g.sh cabioqa/goqa1234@cbtest jdbc:oracle:thin:@cbiodb30.nci.nih.gov:1521:CBTEST cabioqa goqa1234 qa > results_qa_`date '+%m_%d_%y'`.out 2>&1 &
