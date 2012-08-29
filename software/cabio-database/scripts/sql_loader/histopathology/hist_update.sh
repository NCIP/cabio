#!/bin/sh
# Create Gene KW before this
$SQLPLUS $1 @histCode_preprocess.sql
# generate gene_histo.txt
cd $CABIO_DIR/scripts/sql_loader/java
ant histo
cd $CABIO_DIR/scripts/sql_loader/histopathology
#perl splitKeywords.pl
# load gene_histopathology
$SQLLDR $1 readsize=1000000 parallel=true control=geneHisto.ctl log=geneHisto.log bad=geneHisto.bad errors=50000 direct=true silent=(HEADER) 
$SQLPLUS $1 @histCode_postprocess.sql
#$SQLPLUS $1 @context.sql
