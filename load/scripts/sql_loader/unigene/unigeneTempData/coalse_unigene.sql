DECLARE
  counter       INTEGER;
  gene_id_save  INTEGER;
  sql_statement VARCHAR2(500);
BEGIN
  FOR entrez_cur IN
  (SELECT DISTINCT entrez_id
  FROM gene_tv
  WHERE entrez_id IS NOT NULL
  GROUP BY entrez_id
  HAVING COUNT(*) > 1
  )
  LOOP
    counter    :=1;
    FOR unicur IN
    (SELECT gene_id,
      cluster_id,
      entrez_id
    FROM gene_tv
    WHERE entrez_id = entrez_cur.entrez_id
    ORDER BY cluster_id
    )
    LOOP
      IF (counter    =1) THEN
        gene_id_save:=unicur.gene_id;
        counter     :=2;
      ELSE
        sql_statement:='update gene_nucleic_acid_sequence set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and gene_sequence_id not in (select gene_sequence_id from gene_nucleic_acid_sequence where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE sql_statement;
        sql_statement:='delete from gene_nucleic_acid_sequence where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update array_reporter_ch set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update gene_histopathology set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and context_code not in (select context_code from gene_histopathology where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_histopathology where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update gene_function_association set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and NOT EXISTS (SELECT * FROM gene_function_association  WHERE gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_function_association where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);       
        
        sql_statement:='update gene_marker set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and marker_id not in (select marker_id from gene_marker where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_marker where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update transcript_gene set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and transcript_id not in (select transcript_id from transcript_gene where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from transcript_gene where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update cgap_gene_alias set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and alias not in (select alias from cgap_gene_alias where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from cgap_gene_alias where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update cytogenic_location_cytoband set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and chromosome_id not in (select chromosome_id from cytogenic_location_cytoband  where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from cytogenic_location_cytoband  where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update exon_reporter_gene set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and exon_reporter_id not in (select exon_reporter_id from exon_reporter_gene where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from exon_reporter_gene  where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update expression_reporter set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update generic_reporter set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and cluster_id not in (select cluster_id from generic_reporter where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from generic_array_generic_reporter where generic_reporter_id in (select id from generic_reporter where gene_id='||unicur.gene_id||')';
        EXECUTE IMMEDIATE(sql_statement);        
        sql_statement:='delete from generic_reporter where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='update generic_reporter set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update gene_protein_tv set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and protein_id not in (select protein_id from gene_protein_tv where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_protein_tv where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update gene_relative_location set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and snp_id not in (select snp_id from gene_relative_location where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_relative_location where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        sql_statement:='update gene_target set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and target_id not in (select target_id from gene_target where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_target where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update homologous_association set homologous_id ='||gene_id_save||' where homologous_id='||unicur.gene_id||' and homologous_gene_id not in (select homologous_gene_id from homologous_association where homologous_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from homologous_association where homologous_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update homologous_association set homologous_gene_id ='||gene_id_save||' where homologous_id='||unicur.gene_id||' and homologous_id not in (select homologous_id from homologous_association where homologous_gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from homologous_association where homologous_gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update location_tv set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
        
        sql_statement:='update physical_location set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
  
        
        sql_statement:='update gene_genealias set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and alias_id not in (select alias_id from gene_genealias where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from gene_genealias where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        
       
        sql_statement:='update database_cross_reference set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id||' and cross_reference_id not in (select cross_reference_id from database_cross_reference where gene_id='||gene_id_save||')';
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from database_cross_reference where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
 
        sql_statement:='delete from RELATIVE_LOCATION_CH where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
    
    
        sql_statement:='update LOCATION_CH set gene_id ='||gene_id_save||' where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
        sql_statement:='delete from LOCATION_CH where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
    
    
    
        sql_statement:='update LOCATION_CH set CYTO_GENE_ID ='||gene_id_save||' where CYTO_GENE_ID='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);

    
        sql_statement:='delete from gene_tv where gene_id='||unicur.gene_id;
        EXECUTE IMMEDIATE(sql_statement);
      END IF;
    END LOOP;
  END LOOP;
  
  UPDATE DATABASE_CROSS_REFERENCE SET source_name='LOCUS_LINK_ID' where source_name='Entrez';

  UPDATE DATABASE_CROSS_REFERENCE SET SOURCE_TYPE='Entrez gene' WHERE source_type = 'Entrez';

  UPDATE DATABASE_CROSS_REFERENCE SET SOURCE_NAME='CLUSTER_ID' WHERE source_type = 'Unigene' AND source_name='Unigene';
END;
