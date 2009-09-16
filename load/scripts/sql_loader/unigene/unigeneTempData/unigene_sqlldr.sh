#!/bin/sh
$SQLPLUS $1 @unigeneTempData_preprocess.sql
$SQLLDR $1 readsize=1000000 control=zstg_gene.ctl parallel=true  log=zstg_gene.log bad=zstg_gene.bad direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 control=zstg_entrez_gene.ctl parallel=true  log=zstg_entrez_gene.log bad=zstg_entrez_gene.bad direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 control=zstg_gene_identifiers.ctl parallel=true  log=zstg_gene_identifiers.log bad=zstg_gene_identifiers.bad direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 control=zstg_hsmm_seq.ctl parallel=true  log=zstg_hsmm_seq.log bad=zstg_hsmm_seq.bad direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 control=gene_nucleic_acid_sequence.ctl parallel=true log=gene_nucleic_acid_sequence.log bad=gene_nucleic_acid_sequence.bad  direct=true silent=HEADER   errors=5000 &
$SQLLDR $1 readsize=1000000 control=zstg_gene_markers.ctl parallel=true log=zstg_gene_markers.log bad=zstg_gene_markers.bad  direct=true silent=HEADER   errors=5000 &
wait
$SQLPLUS $1 @unigeneTempData_postprocess.sql &

