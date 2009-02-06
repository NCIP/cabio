#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_snp_illumina.ctl log=ZSTG_SNP_ILLUMINA.log bad=ZSTG_SNP_ILLUMINA.bad direct=true silent=(HEADER)   errors=50000 skip=1
