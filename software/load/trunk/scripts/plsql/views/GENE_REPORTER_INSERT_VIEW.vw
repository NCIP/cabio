CREATE OR REPLACE FORCE VIEW CABIODEV.GENE_REPORTER_INSERT_VIEW
(REPORTER_ID, GENE_ID, ARRAY_DESIGN_ID)
AS 
SELECT DISTINCT /*+ INDEX(SEQUENCE CLONE_NAME_IND) */ reporter_id, gene_id, 
                    array_design_id 
              FROM (SELECT /*+ RULE */ 
                            array_design_id, reporter_id, reporter_name 
                      FROM dcop.reporter@todcop a, 
                           dcop.design_element_group@todcop b 
                     WHERE b.design_element_group_id = 
                                                     a.design_element_group_id), 
                   SEQUENCE, 
                   gene_sequence, 
                   CLONE 
             WHERE CLONE.clone_id = SEQUENCE.clone_id 
               AND gene_sequence.sequence_id = SEQUENCE.sequence_id 
               AND CLONE.clone_name = reporter_name;


