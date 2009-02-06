#!/bin/sh
rm indexes/*
rm constraints/*
rm triggers/*
rm *.log *.bad

echo "Disabling all referential integrity constraints \n";
cd $CABIO_DIR/scripts/sql_loader
time sqlplus $1 @$LOAD/all_ref_constraints.sql 1>>refConstraints.log
time sqlplus $1 @$LOAD/constraints/disable.referential.sql >>refConstraints.log

cd $LOAD/arrays
rm *.log
rm *.bad
echo "Loading Array Staging tables"
time sh sql_ldr_arrays_g.sh $1 1>arrayLoad.log 2>&1 

echo "Finished Load 3.0 " |  mail -s " Finished Load P0: Array Loads " viswanathl@mail.nih.gov
mail -s "ARRAY Staging Log " viswanathl@mail.nih.gov < $LOAD/arrays/arrayLoad.log 

cd $LOAD/snp
echo "Loading SNP Data\n"
rm *.bad *.log
time sh NCBI_SNPData_SQLLdr_DataLoader.sh $1 1>snp_load.log 2>&1 &

cd $LOAD/protein
echo "Loading  PROTEIN_* objects"
rm *.bad *.log
time sh UniprotProtein_SQLLdr_DataLoader.sh $1 1> protein_load.log 2>&1 &

cd $LOAD/unigene/gene 
echo "Loading gene, Unigene, Clone and UnigeneTmpData"
rm *.bad *.log
time sh geneTv_sqlldr.sh $1 1>geneTv_load.log 2>&1 

cd $LOAD/unigene/nas 
time sh nas_sqlldr.sh $1 1>nas_load.log 2>&1 &

cd $LOAD/unigene/clone 
time sh cloneTables_sqlldr.sh $1 1>cloneTables_load.log 2>&1 &

cd $LOAD/unigene/unigeneTempData 
time sh unigene_sqlldr.sh $1 1>unigene_sqlldr.log 2>&1 &

cd $LOAD/unigene2gene 
echo "Loading zstg_gene2UNIGENE, zstg_omim2gene, zstg_gene2ACCESSION and other Entrez-Id mapping tables"
rm *.bad *.log
time sh unigene2gene_sqlldr.sh $1 1>unigene2gene_load.log 2>&1 &

cd $LOAD/relative_clone
echo "Loading EST and mRNA Staging tables"
rm *.bad *.log
time sh all_est_mrna_sqlldr.sh $1 1>estmrna_load.log 2>&1 &

cd $LOAD/ctep
echo "Loading CTEP data"
rm *.bad *.log
time sh ctep.sh $1 1>ctep_load.log 2>&1 &

wait

cd $LOAD/cytoband
echo "Loading cytoband tables"
rm *.bad *.log
time sh Cytoband_SQLLdr_DataLoader.sh $1 1>cytoband_load.log 2>&1 

cd $LOAD/marker
echo "Loading UniSTS Marker Data"
rm *.bad *.log
time sh markerLoad.sh $1 1>marker_load.log 2>&1 &

wait
mail -s "SNP Load" viswanathl@mail.nih.gov < $LOAD/snp/snp_load.log
mail -s "Protein Load" viswanathl@mail.nih.gov < $LOAD/protein/protein_load.log
mail -s "Marker load Log " viswanathl@mail.nih.gov < $LOAD/marker/marker_load.log 
mail -s "cytoband Log " viswanathl@mail.nih.gov < $LOAD/cytoband/cytoband_load.log 
mail -s "ctep Log " viswanathl@mail.nih.gov < $LOAD/ctep/ctep_load.log 
mail -s "est mrna Log " viswanathl@mail.nih.gov < $LOAD/relative_clone/estmrna_load.log 
mail -s "nas Log " viswanathl@mail.nih.gov < $LOAD/unigene/nas/nas_load.log 
mail -s "Gene Log " viswanathl@mail.nih.gov < $LOAD/unigene/gene/geneTv_load.log 

echo "Finished Part 1 " |  mail -s " Part 1 over " viswanathl@mail.nih.gov

cd $LOAD/dbcrossref
echo "Loading database_cross_reference "
time sh DatabaseCrossReference.sh $1 1>dbCrossRef.log 2>&1 &

cd $LOAD/homologene
echo "Loading homologous_association "
time sqlplus $1 @homoloGene_ld.sql 1>homoloGene.log 2>&1 &

cd $LOAD/GO
echo "Loading gene_ONTOLOGY tables"
time sqlplus $1 @loadGo.sql 1>GO.log 2>&1 & 

cd $LOAD/sql
echo "Loading gene_protein_tv "
time sqlplus $1 @Gene_Protein_TV_LD.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/sql
echo "Loading generic_reporter-related tables"
time sqlplus $1 @GenericReporter_ld.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/sql
echo "Loading target-related tables"
time sqlplus $1 @target_ld.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/sql
echo "Loading gene-organONTOLOGY table"
time sqlplus $1 @gene_organontology.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/sql
echo "Loading PATHWAYS tables"
time sqlplus $1 @loadPathways.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/sql
echo "Loading Gene-Alias tables"
time sqlplus $1 @geneAlias_ld.sql 1>>sqlLoad.log 2>&1 

cd $LOAD/pid 
echo "Loading PID tables"
time sh pidLoader.sh $1 1>pidLoader.log 2>&1 

echo "Finished Load P2 " |  mail -s " Starting Array, CGDC and gene-histo loads"  viswanathl@mail.nih.gov

mail -s "SQL Log " viswanathl@mail.nih.gov < $LOAD/sql/sqlLoad.log 
mail -s "GO Load Log " viswanathl@mail.nih.gov < $LOAD/GO/GO.log 
mail -s "Homologene Log " viswanathl@mail.nih.gov < $LOAD/homologene/homoloGene.log 
mail -s "DatabaseCrossReference Log " viswanathl@mail.nih.gov < $LOAD/dbcrossref/dbCrossRef.log 

cd $LOAD/location
echo "Loading LOCATION tables"
rm *.bad *.log
time sh locationLoad.sh $1 1>locationLoad.log 2>&1 

cd $LOAD/histopathology
echo "Loading gene-histopathology tables"
time sh hist_update.sh $1 1>histLoad.log 2>&1 &

cd $CABIO_DIR/scripts/sql_loader/arrays
echo "Loading ARRAY tables"
rm *.bad *.log
time sh load.sh $1 1>Array_PLSQL_Ld.log 2>&1 

cd $LOAD/cgdc
echo "Loading CGDC data"
rm *.bad *.log
time sh cgdc_sqlldr.sh $1 1>cgdcLoad.log 2>&1 &
wait

mail -s "Histo Load Log " viswanathl@mail.nih.gov < $LOAD/histopathology/histLoad.log 
mail -s "Array PLSQL Log " viswanathl@mail.nih.gov < $LOAD/arrays/Array_PLSQL_Ld.log 
mail -s "CGDC Load Log " viswanathl@mail.nih.gov < $LOAD/cgdc/cgdcLoad.log 

echo "Finished Load P4 " |  mail -s " Beginning grid id " viswanathl@mail.nih.gov


cd $LOAD/provenance
echo "Loading provenance, source_reference, URL_source_reference tables"
rm *.bad *.log
time sh provenance_DataLoader.sh $1  1>provenance_load.log 2>&1 &


# Grid Id Load
time sqlplus $1  @$LOAD/bigid_lower_idx.sql
time sqlplus $1  @$LOAD/indexes/drop.sql

time sqlplus $1 @$LOAD/bigid_unique_constraints.sql 1>>refConstraints.log 
time sqlplus $1 @$LOAD/constraints/disable.bigid.sql 1>>refConstraints.log 

echo "Beginning Grid Id Load for some objects"
cd /cabio/cabiodb/cabio42/grididloader/
rm *.bad *.log
time ant -Dtarget.env=dev  1>$grididload_LOG 2>&1

mail -s " Grid Id Load Log " viswanathl@mail.nih.gov < $CABIO_DIR/gridid/$grididload_LOG 

time sqlplus $1  @$LOAD/indexes/bigid_cols.sql 
time sqlplus $1  @$LOAD/indexes/bigid_lower.sql 

cd $CABIO_DIR/scripts/sql_loader/arrays
echo "Starting post big id load";
time sh post_bigid_load.sh $1 1>postbigid.log 2>&1 

cd $LOAD/mergedSnpRsIds_processing
echo "Loading MergedSNP Ids tables"
rm *.bad *.log
time sh MergedSNPIds_Wrapper.sh $1 1>mergedIdProcessing.log 2>&1 

cd $LOAD/location
echo "Loading LOCATION tables"
time sh postbigid.sh $1 1>>locationLoad.log 2>&1 


mail -s " Post Big Id Load Log " viswanathl@mail.nih.gov < postbigid.log 
mail -s " Location Log " viswanathl@mail.nih.gov < locationLoad.log 
mail -s " Merged SNP Id Log " viswanathl@mail.nih.gov < mergedIdProcessing.log 

cd $LOAD
time sqlplus $1 @$LOAD/constraints/enable.referential.sql 1>>refConstraints.log

time sqlplus $1 @$LOAD/bigid_unique_constraints.sql 1>>refConstraints.log 
time sqlplus $1 @$LOAD/constraints/enable.bigid.sql 1>>refConstraints.log 

echo "Finished Load P8 " |  mail -s " Finished Load P8; finished enabling ref constraints " viswanathl@mail.nih.gov

exit
