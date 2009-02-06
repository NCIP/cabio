#!/bin/sh

$SQLLDR $1 readsize=100000 control=zstg_exon_affy.ctl log=zstg_exon_affy.log bad=ZSTG_EXON_AFFY.bad direct=true silent=(HEADER) errors=50000 skip=1
$SQLLDR $1 readsize=2000000 control=zstg_exon_trans_affy.ctl log=zstg_exon_trans_affy.log bad=ZSTG_EXON_TRANS_AFFY.bad silent=(HEADER) direct=true errors=50000 skip=1
$SQLLDR $1 readsize=1000000 control=zstg_exon_trans_genes.ctl log=zstg_exon_trans_genes.log bad=ZSTG_EXON_TRANS_GENES.bad direct=true silent=(HEADER)   errors=50000
