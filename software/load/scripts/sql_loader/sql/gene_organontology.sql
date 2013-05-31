/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE gene_expressed_in; 
@$LOAD/indexer_new.sql gene_expressed_in 
@$LOAD/constraints.sql gene_expressed_in 
@$LOAD/triggers.sql gene_expressed_in 

@$LOAD/constraints/gene_expressed_in.disable.sql
@$LOAD/indexes/gene_expressed_in.drop.sql
@$LOAD/triggers/gene_expressed_in.disable.sql

INSERT INTO gene_expressed_in(gene_id, organ_id) SELECT G.gene_id, tissue_code FROM gene_tv G, CGAP.HS_GENE_TISSUE@WEB.NCI.NIH.GOV HGT WHERE CLUSTER_ID = HGT.CLUSTER_NUMBER AND G.taxon_ID = 5 UNION SELECT G.gene_id, TISSUE_CODE FROM GENE_TV G, CGAP.MM_GENE_TISSUE@WEB.NCI.NIH.GOV MGT WHERE CLUSTER_ID = MGT.CLUSTER_NUMBER AND G.TAXON_ID = 6;
COMMIT;

@$LOAD/indexes/gene_expressed_in.cols.sql
@$LOAD/indexes/gene_expressed_in.lower.sql
@$LOAD/constraints/gene_expressed_in.enable.sql
@$LOAD/triggers/gene_expressed_in.enable.sql
EXIT;
