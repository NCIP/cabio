#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_snp_affy.ctl log=ZSTG_SNP_AFFY.log bad=ZSTG_SNP_AFFY.bad direct=true silent=(HEADER)   errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_pop_frequency.ctl log=ZSTG_POP_FREQUENCY.log bad=ZSTG_POP_FREQUENCY.bad direct=true silent=(HEADER)   errors=50000 
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_snp_associated_gene.ctl log=zstg_snp_associated_gene.log bad=ZSTG_SNP_ASSOCIATED_GENE.bad direct=true silent=(HEADER)   errors=5000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_microsatellite.ctl log=ZSTG_MICROSATELLITE.log bad=ZSTG_MICROSATELLITE.bad direct=true silent=(HEADER)   errors=5000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_genetic_map.ctl log=zstg_geneTIC_MAP.log bad=zstg_genetic_map.bad direct=true silent=(HEADER)   errors=5000
