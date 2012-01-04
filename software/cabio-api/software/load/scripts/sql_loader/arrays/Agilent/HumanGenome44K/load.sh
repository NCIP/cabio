#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_rna_agilent.ctl log=ZSTG_RNA_AGILENT.log bad=ZSTG_RNA_AGILENT.bad direct=true silent=(HEADER)   errors=50000 skip=1
