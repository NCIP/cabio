CREATE OR REPLACE PROCEDURE load_pathways
IS
   pathflag    NUMBER;
   pathwayid   NUMBER;
   geneid      NUMBER;
   geneflag    VARCHAR (50);
BEGIN
   EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOGENES_TEMP REUSE STORAGE ');
   EXECUTE IMMEDIATE ('TRUNCATE TABLE GENE_PATHWAY REUSE STORAGE ');
   EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOGENES REUSE STORAGE ');
   EXECUTE IMMEDIATE ('TRUNCATE TABLE BIOPATHWAY_DESCR_TEMP REUSE STORAGE ');

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
       WHERE pathway_name = pathrec.pathway_name AND taxon = pathrec.taxon_id;

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
                 FROM biogenes_temp bt, gene_identifiers gi
                WHERE bt.locus_id = gi.IDENTIFIER(+) AND gi.data_source(+) = 2;

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
/

