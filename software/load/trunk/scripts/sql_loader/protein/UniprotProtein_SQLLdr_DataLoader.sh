#!/bin/sh

echo "Loading Uniprot Protein Data using SQL Loader"
$SQLPLUS $1 @proteinData_preprocess.sql
$SQLLDR $1 readsize=1000000 parallel=true control=new_protein.ctl log=new_protein.log bad=new_protein.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 control=protein_sequence.ctl log=protein_sequence.log bad=protein_sequence.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 parallel=true control=protein_alias.ctl log=protein_alias.log bad=protein_alias.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 parallel=true control=zstg_protein_embl.ctl log=zstg_protein_embl.log bad=zstg_protein_embl.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 parallel=true control=protein_keywords.ctl log=protein_keywords.log bad=protein_keywords.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 parallel=true control=protein_taxon.ctl log=protein_taxon.log bad=protein_taxon.bad direct=true silent=(HEADER)  errors=50000 &
$SQLLDR $1 readsize=1000000 parallel=true control=protein_secondary_accession.ctl log=protein_secondary_accession.log bad=protein_secondary_accession.bad direct=true silent=(HEADER)  errors=50000 &
wait
$SQLPLUS $1 @proteinData_postprocess.sql &
echo "Finished loading Uniprot Protein Data"
