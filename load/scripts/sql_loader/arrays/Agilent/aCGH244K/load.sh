#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_cgh_agilent.ctl log=ZSTG_CGH_AGILENT.log bad=ZSTG_CGH_AGILENT.bad direct=true silent=(HEADER)   errors=50000 skip=1
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_cgh_accessions.ctl log=ZSTG_CGH_ACCESSIONS.log bad=ZSTG_CGH_ACCESSIONS.bad direct=true silent=(HEADER)   errors=50000
