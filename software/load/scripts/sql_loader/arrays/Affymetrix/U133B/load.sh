#!/bin/sh

$SQLLDR $1 readsize=1000000 rows=100000 control=AR_RNA_Probesets_Affy.ctl log=AR_RNA_Probesets_Affy.log bad=AR_RNA_Probesets_Affy.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_representative_public_ID.ctl log=AR_representative_public_ID.log bad=AR_representative_public_ID.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_gene_title.ctl log=AR_gene_title.log bad=AR_gene_title.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_gene_symbol.ctl log=AR_gene_symbol.log bad=AR_gene_symbol.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_chromosomal_location.ctl log=AR_chromosomal_location.log bad=AR_chromosomal_location.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_unigene_ID.ctl log=AR_unigene_ID.log bad=AR_unigene_ID.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_entrez_gene.ctl log=AR_entrez_gene.log bad=AR_entrez_gene.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=ar_ec.ctl log=AR_EC.log bad=AR_EC.bad direct=true errors=50000 skip=1
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_Ensembl.ctl log=AR_Ensembl.log bad=AR_Ensembl.bad direct=true errors=50000 skip=1
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_OMIM.ctl log=AR_OMIM.log bad=AR_OMIM.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_go_biological_process.ctl log=AR_go_biological_process.log bad=AR_go_biological_process.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_go_cellular_component.ctl log=AR_go_cellular_component.log bad=AR_go_cellular_component.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_go_molecular_function.ctl log=AR_go_molecular_function.log bad=AR_go_molecular_function.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_alignments.ctl log=AR_alignments.log bad=AR_alignments.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_pathway.ctl log=AR_pathway.log bad=AR_pathway.bad direct=true errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_refseq_protein.ctl log=AR_refseq_protein.log bad=AR_refseq_protein.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_refseq_transcripts.ctl log=AR_refseq_transcripts.log bad=AR_refseq_transcripts.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=AR_swissprot.ctl log=AR_swissprot.log bad=AR_swissprot.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_rna_probesets.ctl log=ZSTG_RNA_Probesets.ctl.log bad=ZSTG_RNA_Probesets.ctl.bad direct=true skip=13 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=ZSTG_RNA_Probesets_2.ctl log=ZSTG_RNA_Probesets_2.ctl.log bad=ZSTG_RNA_Probesets_2.ctl.bad direct=true skip=13 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_interpro.ctl log=ZSTG_INTERPRO.log bad=ZSTG_INTERPRO.bad skip=1 direct=true errors=50000
