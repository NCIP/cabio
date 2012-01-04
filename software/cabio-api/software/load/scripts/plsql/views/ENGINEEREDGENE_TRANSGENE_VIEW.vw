CREATE OR REPLACE FORCE VIEW CABIODEV.ENGINEEREDGENE_TRANSGENE_VIEW
(CABIOID, CONDITIONALITY_ID, DBCROSSREFS, ENGINEEREDGENE_ID, GENOMICSEGMENT_ID, 
 GENOTYPESUMMARY_ID, IMAGE_ID, INDUCEDMUTATION_ID, LOCUSLINKSUMMARY, NAME, 
 TITLE, TRANSGENE_ID, ANIMALMODEL_ID, INTEGRATIONTYPE_ID, LOCATIONOFINTEGRATION)
AS 
SELECT engineeredgene.cabioid, engineeredgene.conditionality_id, 
          engineeredgene.dbcrossrefs, engineeredgene.engineeredgene_id, 
          engineeredgene.genomicsegment_id, engineeredgene.genotypesummary_id, 
          engineeredgene.image_id, engineeredgene.inducedmutation_id, 
          engineeredgene.locuslinksummary, engineeredgene.NAME, 
          engineeredgene.title, transgene.transgene_id, 
          transgene.animalmodel_id, transgene.integrationtype_id, 
          transgene.locationofintegration 
     FROM engineeredgene, transgene 
    WHERE engineeredgene.engineeredgene_id = transgene.engineeredgene_id;


