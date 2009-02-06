#!/bin/sh
echo "Loading Gene to Unigene, Gene to Accession and OMIM to Gene Ids Mapping"
$SQLPLUS $1 @mappingData_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_gene2accessions_sqlldr.ctl log=zstg_gene2accessions_sqlldr.log bad=zstg_gene2accessions_sqlldr.bad direct=true skip_index_maintenance=true errors=5000 skip=1 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_gene2unigene_sqlldr.ctl log=zstg_gene2unigene_sqlldr.log bad=zstg_gene2unigene_sqlldr.bad direct=true skip_index_maintenance=true errors=5000 skip=1 &
$SQLLDR $1 readsize=1000000 parallel=true rows=100000 control=zstg_omim2gene_sqlldr.ctl log=zstg_omim2gene_sqlldr.log bad=zstg_omim2gene_sqlldr.bad direct=true skip_index_maintenance=true errors=5000 skip=1 &
$SQLLDR $1 readsize=1000000 rows=100000 control=geneAlias.ctl log=geneAlias.log bad=geneAlias.bad direct=true skip_index_maintenance=true errors=5000 skip=1 &
$SQLLDR $1 readsize=1000000 parallel=true control=zstg_gene2refseq_sqlldr.ctl log=zstg_gene2refseq_sqlldr.log bad=zstg_gene2refseq_sqlldr.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true &
$SQLLDR $1 readsize=1000000 parallel=true control=zstg_seqgene.ctl log=zstg_seqgene.log bad=zstg_seqgene.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true skip=1 &
$SQLLDR $1 readsize=1000000 parallel=true control=zstg_seqsts.ctl log=zstg_seqsts.log bad=zstg_seqsts.bad errors=50000 direct=true silent=(HEADER) skip_index_maintenance=true skip=1 &

wait
$SQLPLUS $1 @mappingData_postprocess.sql
