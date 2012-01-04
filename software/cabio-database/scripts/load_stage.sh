#!/bin/sh
cd $CABIO_DIR/scripts
nohup sh load_g.sh cabiostage/dev!234@cbstg jdbc:oracle:thin:@cbiodb20.nci.nih.gov:1521:CBSTG cabiostage dev!234 > results_stage.out 2>&1 &
