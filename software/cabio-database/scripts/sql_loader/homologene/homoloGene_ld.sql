/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexer_new.sql homologous_association;
@$LOAD/constraints.sql homologous_association;
@$LOAD/triggers.sql homologous_association;

@$LOAD/constraints/homologous_association.disable.sql;
@$LOAD/triggers/homologous_association.disable.sql;
@$LOAD/indexes/homologous_association.drop.sql;
TRUNCATE TABLE homologous_association REUSE STORAGE;
DROP SEQUENCE HOMOLOgene_LD;
CREATE SEQUENCE HOMOLOgene_ID START WITH 1;
ALTER TRIGGER HOMOLO_ID ENABLE;

INSERT
  INTO homologous_association(HOMOLOGOUS_ID, HOMOLOGOUS_gene_ID, 
SIMILARITY_PERCENTAGE) SELECT DISTINCT HS_ID, MM_ID, SIM FROM (SELECT G.gene_ID 
HS_ID, G2.gene_ID MM_ID, MAX(SIMILARITY) SIM FROM gene_tv G, GENE_TV G2, 
CGAP.MM_TO_HS@WEB.NCI.NIH.GOV GH
WHERE G.CLUSTER_ID = GH.HS_CLUSTER_NUMBER AND G.taxon_ID = 5 AND G2.CLUSTER_ID 
= GH.MM_CLUSTER_NUMBER AND G2.taxon_ID = 6 AND SIMILARITY NOT LIKE 'http%'
  GROUP BY G.gene_ID, G2.GENE_ID UNION SELECT G2.GENE_ID HS_ID, G.GENE_ID MM_ID, 
MAX(SIMILARITY) SIM FROM gene_tv G, gene_tv G2, CGAP.HS_TO_MM@WEB.NCI.NIH.GOV GH
WHERE G.CLUSTER_ID = GH.HS_CLUSTER_NUMBER AND G.taxon_ID = 5 AND G2.CLUSTER_ID 
= GH.MM_CLUSTER_NUMBER AND G2.taxon_ID = 6 AND SIMILARITY NOT LIKE 'http%'
                                                GROUP BY G.gene_ID, G2.GENE_ID);

ALTER TRIGGER HOMOLO_ID DISABLE;
DROP SEQUENCE HOMOLOgene_ID;
@$LOAD/indexes/homologous_association.lower.sql;
@$LOAD/indexes/homologous_association.cols.sql;
@$LOAD/constraints/homologous_association.enable.sql;
@$LOAD/triggers/homologous_association.enable.sql;
EXIT;
