CREATE OR REPLACE FORCE VIEW CABIODEV.REGULATORYELEMENT_PROMOTER_V
(NAME, REGULATORYELEMENT_ID, REGULATORYELEMENTTYPE_ID, TAXON_ID, TRANSGENE_ID, 
 GENE_ID, PROMOTER_ID)
AS 
SELECT regulatoryelement.NAME, regulatoryelement.regulatoryelement_id, 
          regulatoryelement.regulatoryelementtype_id, 
          regulatoryelement.taxon_id, regulatoryelement.transgene_id, 
          promoter.gene_id, promoter.promoter_id 
     FROM regulatoryelement, promoter 
    WHERE regulatoryelement.regulatoryelement_id = 
                                                 promoter.regulatoryelement_id;


