CREATE OR REPLACE PACKAGE load_goevsmod
AS
   PROCEDURE load_pathways;
   PROCEDURE getgo_rela;
   PROCEDURE getevs;
   PROCEDURE getmod;
END load_goevsmod; 
/
CREATE OR REPLACE PACKAGE BODY load_goevsmod
AS
   PROCEDURE load_pathways
   IS
      pathflag    NUMBER;
      pathwayid   NUMBER;
      geneid      NUMBER;
      geneflag    VARCHAR (50);

   BEGIN

      EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOGENES_TEMP REUSE STORAGE ');
      EXECUTE IMMEDIATE ('TRUNCATE TABLE GENE_PATHWAY REUSE STORAGE ');
      EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOGENES REUSE STORAGE ');
      EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOPATHWAY_DESCR_TEMP REUSE STORAGE '
                        );

      FOR pathrec IN (SELECT DISTINCT pathway_name, pathway_display,
                                      DECODE (organism,
                                              'Hs', 5,
                                              'Mm', 6
                                             ) taxon_id
                                 FROM cgap.biopaths@web.nci.nih.gov)
      LOOP
         SELECT COUNT (*)
           INTO pathflag
           FROM bio_pathways
          WHERE pathway_name = pathrec.pathway_name
            AND taxon = pathrec.taxon_id;

         IF pathflag = 0
         THEN

            BEGIN

               SELECT NVL (MAX (pathway_id), 0) + 1
                 INTO pathwayid
                 FROM bio_pathways;

               INSERT INTO bio_pathways
                           (pathway_id, pathway_name,
                            pathway_display, taxon
                           )
                    VALUES (pathwayid, pathrec.pathway_name,
                            pathrec.pathway_display, pathrec.taxon_id
                           );

            EXCEPTION

               WHEN OTHERS
               THEN
                  NULL;
            END;

         ELSE

            BEGIN

               UPDATE bio_pathways
                  SET pathway_display = pathrec.pathway_display
                WHERE pathway_name = pathrec.pathway_name
                  AND taxon = pathrec.taxon_id;

            EXCEPTION

               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      END LOOP;

      INSERT INTO biogenes_temp
         SELECT DISTINCT pathway_name,
                         DECODE (biog.organism,
                                 'Hs', biog.bc_id,
                                 'Mm', 'Mm.' || biog.bc_id
                                ),
                         locus_id,
                         DECODE (biog.organism, 'Hs', 5, 'Mm', 6) taxon_id
                    FROM cgap.biopaths@web.nci.nih.gov biop,
                         cgap.biogenes@web.nci.nih.gov biog
                   WHERE biog.bc_id = biop.bc_id(+)
                         AND biog.organism = biop.organism;

      INSERT INTO biogenes
                  (bc_id, locus_id, organism, gene_id)
         SELECT DISTINCT bc_id, locus_id, taxon_id, gene_id
                    FROM biogenes_temp bt, gene_identifiers_stg31 gi
                   WHERE bt.locus_id = gi.IDENTIFIER(+)
                     AND gi.data_source(+) = 2;

      INSERT INTO gene_pathway
                  (pathway_id, bc_id)
         SELECT DISTINCT pathway_id, bc_id
                    FROM bio_pathways bp, biogenes_temp bg
                   WHERE bp.pathway_name = bg.pathway_name
                     AND bp.taxon = bg.taxon_id
                     AND bg.pathway_name IS NOT NULL;

      INSERT INTO biopathway_descr_temp
         SELECT *
           FROM cgap.biopathway_descr@web;

      UPDATE bio_pathways a
         SET a.pathway_desc = (SELECT pathway_descr
                                 FROM biopathway_descr_temp b
                                WHERE b.path_id = a.pathway_name);

      COMMIT;

   EXCEPTION

      WHEN OTHERS
      THEN
         NULL;

   END;



   PROCEDURE getgo_rela
   IS
      CURSOR getrecs
      IS
         SELECT  * from go_relationship FOR UPDATE;
         counter   NUMBER := 0;

   BEGIN

      FOR arec IN getrecs
      LOOP
         counter := counter + 1;

         UPDATE go_relationship
            SET ID = counter
          WHERE CURRENT OF getrecs;
      END LOOP;

      COMMIT;

   EXCEPTION

      WHEN OTHERS
      THEN
         --ROLLBACK TO myTrans;
         NULL;

   END;


   PROCEDURE getevs
   IS
      CURSOR getrecs
      IS
         SELECT     *
               FROM evs_concept_relationship
         FOR UPDATE;
         counter   NUMBER := 0;

   BEGIN

      FOR arec IN getrecs
      LOOP
         counter := counter + 1;

         UPDATE evs_concept_relationship
            SET ID = TO_CHAR (counter)
          WHERE CURRENT OF getrecs;
      END LOOP;

      COMMIT;

   EXCEPTION

      WHEN OTHERS
      THEN
         --ROLLBACK TO myTrans;
         NULL;

   END;



   PROCEDURE getmod
   IS
      CURSOR getgenerecs
      IS
         SELECT *
           FROM engineeredgene
          WHERE cabioid > 0;

      CURSOR gethistdiseaserecs
      IS
         SELECT *
           FROM histopathology_disease;

      CURSOR getcontextrecs
      IS
         SELECT *
           FROM CONTEXT;

      CURSOR getupperhistrecs (ctxmaxid CONTEXT.context_code%TYPE)
      IS
         SELECT *
           FROM histopathology
          WHERE histopathology_id > ctxmaxid;

      CURSOR getlowerhistrecs (ctxmaxid CONTEXT.context_code%TYPE)
      IS
         SELECT *
           FROM histopathology
          WHERE histopathology_id <= ctxmaxid;

      ctxrec      CONTEXT%ROWTYPE;
      histrec     histopathology%ROWTYPE;
      maxctxid    NUMBER;
      maxhistid   NUMBER;

   BEGIN

      UPDATE gene a
         SET locus_link_id = (SELECT IDENTIFIER
                                FROM gene_identifiers
                               WHERE data_source = 2
                                 AND gene_id = a.gene_id);

      COMMIT;

      UPDATE gene a
         SET omim_id = (SELECT IDENTIFIER
                          FROM gene_identifiers
                         WHERE data_source = 3
                           AND gene_id = a.gene_id);

      COMMIT;

      --GET THE MAX ID
      SELECT MAX (context_code)
        INTO maxctxid
        FROM CONTEXT;

      --SAVEPOINT myTrans;

      DELETE FROM histopathology_tst;

      --MOVE OVER THE STUFF FROM CONTEXT
      FOR arec IN getcontextrecs
      LOOP
         INSERT INTO histopathology_tst
                     (histopathology_id, tissue_code,
                      histology_code
                     )
              VALUES (arec.context_code, arec.tissue_code,
                      arec.histology_code
                     );
      END LOOP;

      --MOVE OVER THE STUFF FROM HISTOPATHOLOGY
      FOR arec IN getupperhistrecs (maxctxid)
      LOOP
         INSERT INTO histopathology_tst
                     (histopathology_id, survivalinfo,
                      tumorincidencerate, comments,
                      relationaloperation, microscopicdescription,
                      grossdescription, ageofonset,
                      metastasisof, animalmodel_id,
                      organ_id
                     )
              VALUES (arec.histopathology_id, arec.survivalinfo,
                      arec.tumorincidencerate, arec.comments,
                      arec.relationaloperation, arec.microscopicdescription,
                      arec.grossdescription, arec.ageofonset,
                      arec.metastasisof, arec.animalmodel_id,
                       'C' || TO_CHAR (arec.organ_id)
                     );
      END LOOP;

      SELECT MAX (histopathology_id)
        INTO maxhistid
        FROM histopathology_tst;

      --SHIFT UP THE LOWER HISTOPATHOLOGY RECORDS
      FOR arec IN getlowerhistrecs (maxctxid)
      LOOP
         INSERT INTO histopathology_tst
                     (histopathology_id, survivalinfo,
                      tumorincidencerate, comments,
                      relationaloperation, microscopicdescription,
                      grossdescription, ageofonset,
                      metastasisof, animalmodel_id,
                      organ_id
                     )
              VALUES (arec.histopathology_id + maxhistid, arec.survivalinfo,
                      arec.tumorincidencerate, arec.comments,
                      arec.relationaloperation, arec.microscopicdescription,
                      arec.grossdescription, arec.ageofonset,
                      arec.metastasisof, arec.animalmodel_id,
                       'C' || TO_CHAR (arec.organ_id)
                     );

         --UPDATE THE HISTPATHOLOGY_DISEASE TABLE
         UPDATE histopathology_disease
            SET histopathology_id = arec.histopathology_id + maxhistid
          WHERE histopathology_id = arec.histopathology_id;
      END LOOP;

      --MOVE THE REFERENCED ENGINEEREDGENES TO THE GENE TABLE
      --UPDATE THE HISTPATHOLOGY_DISEASE TABLE
      UPDATE gene a
         SET engineeredgene_id =
                    (SELECT engineeredgene_id
                       FROM engineeredgene
                      WHERE TO_CHAR (cabioid) = a.locus_link_id
                        AND ROWNUM < 2);
      COMMIT;

   EXCEPTION

      WHEN OTHERS
      THEN
         --ROLLBACK TO myTrans;
         NULL;
   END;



END load_goevsmod; 
/

