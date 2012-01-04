#!/bin/sh
echo Loading nucleic_acid_sequence table
$SQLPLUS $1 @nasData_preprocess.sql
$SQLLDR $1 readsize=1000000 direct=true silent=HEADER  control=nucleic_acid_sequence.ctl log=nucleic_acid_sequence.log bad=nucleic_acid_sequence.bad errors=5000
$SQLPLUS $1 @nasData_postprocess.sql  
echo Finished loading nucleic_acid_sequence table
