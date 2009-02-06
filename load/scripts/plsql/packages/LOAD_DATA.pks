CREATE OR REPLACE PACKAGE Load_Data AS
  PROCEDURE load_libraries;
  PROCEDURE load_unigene;
  FUNCTION  get_chromosome(cytoloc_in VARCHAR2, taxon_id_in NUMBER) RETURN NUMBER;
  FUNCTION  get_taxon(taxon_abbr VARCHAR2, strain_name VARCHAR2) RETURN NUMBER;
  PROCEDURE set_svclones(clone_ids_in VARCHAR2);
  PROCEDURE set_ref_seq(ref_seq_ids_in IN VARCHAR2, geneID NUMBER);
  PROCEDURE load_tissues_and_histologies;
  PROCEDURE load_pathways;
  PROCEDURE load_go;
  PROCEDURE load_homologues;
  PROCEDURE load_protein_homologues;
  PROCEDURE load_cmap;
  PROCEDURE load_targets;
  PROCEDURE fix_sequences;
  PROCEDURE fix_clones;
  PROCEDURE load_snps;
  PROCEDURE analyze_tables;
  PROCEDURE load_dc;
END; 
/
CREATE OR REPLACE PACKAGE BODY Load_Data AS

PROCEDURE analyze_tables
  IS
  BEGIN
  FOR cur IN(SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE ('ANALYZE TABLE ' || cur.table_name || ' ESTIMATE STATISTICS');
  END LOOP;
END;
FUNCTION GET_PROTOCOL(prot_type VARCHAR2,
                      prot_name VARCHAR2) RETURN NUMBER
IS
 return_value NUMBER := -1;
BEGIN
  FOR prot_rec IN (SELECT * FROM PROTOCOL
                        WHERE protocol_name = prot_name
					      AND protocol_type = prot_type) LOOP
      return_value := prot_rec.protocol_id;
  END LOOP;
  IF return_value = -1 THEN
     SELECT MAX(protocol_id) + 1 INTO return_value
	   FROM PROTOCOL;
	 INSERT INTO PROTOCOL(protocol_name,
                          protocol_type,
                          protocol_id)
			VALUES(prot_name,
			       prot_type,
				   return_value);
	  COMMIT;
  END IF;
  RETURN return_value;
END GET_PROTOCOL;


FUNCTION GET_TAXON(taxon_abbr VARCHAR2,
                   strain_name VARCHAR2) RETURN NUMBER
IS
 return_value NUMBER := NULL;
BEGIN
  IF strain_name IS NOT NULL AND strain_name <> '' THEN
       FOR taxon_rec IN (SELECT MIN(taxon_id) TAXON FROM TAXON
                          WHERE abbreviation = taxon_abbr
		    		        AND strain_or_ethnicity = trim(strain_name) ORDER BY TAXON_ID) LOOP
       return_value := taxon_rec.TAXON;
       END LOOP;
  ELSE
       FOR taxon_rec IN (SELECT MIN(taxon_id) TAXON FROM TAXON
                          WHERE abbreviation = taxon_abbr
		    		        AND strain_or_ethnicity IS NULL ORDER BY TAXON_ID) LOOP
       return_value := taxon_rec.TAXON;
       END LOOP;

  END IF;
  IF return_value IS NULL THEN
     SELECT MAX(taxon_id) + 1 INTO return_value
	   FROM TAXON;
	 INSERT INTO TAXON(abbreviation,
                       strain_or_ethnicity,
                       taxon_id)
			VALUES(taxon_abbr,
			       strain_name,
				   return_value);
	  COMMIT;
  END IF;
  RETURN return_value;
END GET_TAXON;

FUNCTION GET_SAMPLE_ID(library_ids_in VARCHAR2, taxon_id_in NUMBER) RETURN NUMBER
IS
 table_to_receive Pk_Genutilitypkg.t_string;
 library_counter NUMBER;
 sampleID NUMBER := NULL;
BEGIN
    IF library_ids_in IS NOT NULL THEN
     Pk_Genutilitypkg.sp_parsestring (
      library_ids_in,
      ' ',
      table_to_receive
      );
	  FOR library_counter IN 1 .. table_to_receive.COUNT LOOP
        IF table_to_receive (library_counter) IS NOT NULL THEN
		  SELECT MAX(sample_id) INTO sampleID
		    FROM TISSUE_SAMPLE, LIBRARY
		   WHERE LIBRARY.tissue_id = TISSUE_SAMPLE.tissue_id
		     AND library_id = TRIM(table_to_receive (library_counter));
	    END IF;
		EXIT WHEN sampleID IS NOT NULL;
	  END LOOP;
	END IF;
	  IF sampleID IS NULL THEN
	      SELECT NVL(MAX(SAMPLE_ID), 0) + 1 INTO sampleID
		    FROM SAMPLE;
          INSERT INTO SAMPLE(sample_id,
		                     taxon_id)
				 VALUES(sampleID,
	  		        taxon_id_in);
       END IF;
       RETURN sampleID;
END GET_SAMPLE_ID;

PROCEDURE load_keywords(library_id_in NUMBER, keywords VARCHAR2)
IS
 table_to_receive Pk_Genutilitypkg.t_string;
 keyword_counter NUMBER;
 found_histology NUMBER := -100;
 found_tissue NUMBER := -100;
 found_context NUMBER := -100;
 found_lib_histo NUMBER := 0;
BEGIN
     Pk_Genutilitypkg.sp_parsestring (
      keywords,
      ',',
      table_to_receive
      );
	  FOR keyword_counter IN 1 .. table_to_receive.COUNT LOOP
        IF table_to_receive (keyword_counter) IS NOT NULL THEN
          INSERT INTO LIBRARY_KEYWORD(library_id,
		                              keyword)
				 VALUES(library_id_in,
				        TRIM(table_to_receive (keyword_counter)));
		 END IF;
		IF found_histology = -100 THEN
	       SELECT NVL(MAX(HISTOLOGY_CODE), -100) INTO found_histology FROM HISTOLOGY_CODE WHERE histology_name = TRIM(table_to_receive (keyword_counter));
		END IF;
	    IF found_tissue = -100 THEN
	       SELECT NVL(MAX(TISSUE_CODE), -100) INTO found_tissue FROM TISSUE_CODE WHERE tissue_name = TRIM(table_to_receive (keyword_counter));
		END IF;
        IF found_histology <> -100 AND found_tissue <> -100 THEN
		    SELECT NVL(MAX(CONTEXT_CODE), -100) INTO found_context
			  FROM CONTEXT
			 WHERE TISSUE_CODE = found_tissue
			   AND HISTOLOGY_CODE = found_histology;
			IF found_context = -100 THEN
			   SELECT MAX(context_code) + 1 INTO found_context FROM CONTEXT;
			   INSERT INTO CONTEXT(CONTEXT_CODE, TISSUE_CODE, HISTOLOGY_CODE)
			        VALUES (found_context, found_tissue, found_histology);
			END IF;
		    SELECT COUNT(*) INTO found_lib_histo
			   FROM LIBRARY_HISTOPATHOLOGY
			  WHERE library_id = library_id_in
			    AND context_code = found_context;
		    IF found_lib_histo = 0 THEN
		       INSERT INTO LIBRARY_HISTOPATHOLOGY(library_id,
		                                          context_code)
				 VALUES(library_id_in,
				        found_context);
			END IF;
		 END IF;

	  END LOOP;
END load_keywords;


PROCEDURE load_libraries IS
  lib_protocol NUMBER;
  tis_protocol NUMBER;
  taxonID NUMBER;
  tissueID NUMBER;
  sampleID NUMBER;
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE LIBRARY REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE TISSUE_SAMPLE REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE SAMPLE REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE LIBRARY_KEYWORD REUSE STORAGE ');

SELECT NVL(MAX(TISSUE_ID), 0) + 1 INTO tissueID
  FROM TISSUE_SAMPLE;

FOR librec IN (SELECT * FROM cgap.ALL_LIBRARIES@WEB.NCI.NIH.GOV) LOOP
  lib_protocol := get_protocol('LIBRARY', librec.the_prot);
  tis_protocol := get_protocol('TISSUE', librec.the_prep);
  taxonID := get_taxon(librec.org, librec.STRAIN);
  sampleID := get_sample_id(librec.ids_lib_tissue_sample, taxonID);

   INSERT INTO TISSUE_SAMPLE(TISSUE_NAME,
                             ORGAN,
                             SUPPLIER,
                             HISTOLOGY,
                             DESCRIPTION,
							 TISSUE_ID,
							 SAMPLE_ID,
							 TISSUE_PROTOCOL)
       VALUES(librec.THE_TISS,
              librec.THE_TISS,
			  librec.TISSUE_SUPPLIER,
              librec.THE_HIST,
              librec.TISSUE_DESC,
			  tissueID,
			  sampleID,
			  tis_protocol);


   INSERT INTO LIBRARY(LIBRARY_ID,
                       CLONES_TO_DATE,
		   			   KEYWORD,
			   		   LAB_HOST,
					   LIBRARY_NAME,
					   R_SITE_1,
					   R_SITE_2,
					   SEQUENCES_TO_DATE,
					   DESCRIPTION,
					   LIBRARY_PROTOCOL,
					   TISSUE_PROTOCOL,
					   TISSUE_ID,
					   TAXON_ID,
					   UNIGENE_ID,
					   VECTOR,
					   VECTOR_TYPE,
					   PRODUCER)
		VALUES (librec.LIBRARY_ID,
        	   librec.CLONES_DATE,
			   librec.KEYWORD,
			   librec.LAB_HOST,
			   librec.LIB_NAME,
			   librec.R_SITE1,
			   librec.R_SITE2,
			   librec.SEQUENCES_DATE,
			   librec.DESCRIPTION,
			   lib_protocol,
			   tis_protocol,
			   tissueID,
			   taxonID,
			   librec.UNIGENE_ID,
			   librec.VECTOR,
			   librec.VECTOR_TYPE,
			   librec.PRODUCER);
	 load_keywords(librec.LIBRARY_ID, librec.KEYWORD);
     tissueID := tissueID + 1;
     COMMIT;
  END LOOP;

END load_libraries;

FUNCTION GET_CHROMOSOME(cytoloc_in VARCHAR2, taxon_id_in NUMBER) RETURN NUMBER
IS
 chromosome_lookup_value VARCHAR2(10) := NULL;
 return_value NUMBER := NULL;
 cytoloc VARCHAR2(50) := UPPER(cytoloc_in);
BEGIN

  IF LENGTH(cytoloc) > 0 THEN
     IF SUBSTR(cytoloc, 1, 1) = 'X' THEN
	    chromosome_lookup_value := 'X';
     ELSIF SUBSTR(cytoloc, 1, 1) = 'Y' THEN
	    chromosome_lookup_value := 'Y';
	 ELSIF INSTR(cytoloc, 'P') > 1 THEN
	    chromosome_lookup_value := SUBSTR(cytoloc, 1, INSTR(cytoloc, 'P') - 1);
	 ELSIF INSTR(cytoloc, 'Q') > 1 THEN
	    chromosome_lookup_value := SUBSTR(cytoloc, 1, INSTR(cytoloc, 'Q') - 1);
     END IF;
	 IF chromosome_lookup_value IS NOT NULL THEN
        FOR chrom_rec IN (SELECT * FROM CHROMOSOME
                           WHERE chromosome_number = chromosome_lookup_value
	     			         AND taxon_id = taxon_id_in) LOOP
              return_value := chrom_rec.chromosome_id;
	    END LOOP;
     END IF;
  END IF;
  RETURN return_value;
END GET_CHROMOSOME;

PROCEDURE SET_SVCLONES(clone_ids_in IN VARCHAR2)
IS
 table_to_receive Pk_Genutilitypkg.t_string;
 clone_counter NUMBER;
 cloneName VARCHAR2(50);
 access_name_switch VARCHAR2(10) := 'NAME';
 accessionNumber VARCHAR2(50);
 clone_ids VARCHAR2(1000) := clone_ids_in;
BEGIN

    IF clone_ids_in IS NOT NULL THEN
	clone_ids := TRANSLATE(clone_ids, CHR(2), CHR(3));
     Pk_Genutilitypkg.sp_parsestring (
      clone_ids,
      CHR(3),
      table_to_receive
      );

	  /* we need to have id divisable by 2 */
	  IF MOD(table_to_receive.COUNT, 2) = 0 THEN

	     FOR library_counter IN 1 .. table_to_receive.COUNT LOOP
		     IF access_name_switch = 'NAME' THEN
		        cloneName := 'IMAGE:' || table_to_receive (library_counter);
			    access_name_switch := 'ACCESSION';
		     ELSE
		        access_name_switch := 'NAME';
		        accessionNumber := table_to_receive (library_counter);
			    UPDATE CLONE
			       SET accession_number = accessionNumber,
				       verified         = 1
			     WHERE clone_name       = cloneName;
	         END IF;
		  END LOOP;
	  END IF;
	END IF;
  EXCEPTION
	 WHEN OTHERS THEN
	  NULL;
END SET_SVCLONES;


PROCEDURE SET_REF_SEQ(ref_seq_ids_in IN VARCHAR2, geneID NUMBER)
IS
 table_to_receive Pk_Genutilitypkg.t_string;
 seq_counter NUMBER;
 accessionNumber VARCHAR2(50);
BEGIN

    IF ref_seq_ids_in IS NOT NULL THEN
     Pk_Genutilitypkg.sp_parsestring (
      ref_seq_ids_in,
      ' ',
      table_to_receive
      );
    FOR seq_counter IN 1 .. table_to_receive.COUNT LOOP
	    dbms_output.put_line(table_to_receive(seq_counter) || '-' || geneID );
	    UPDATE GENE_SEQUENCE
		   SET is_ref_sequence = 1
	     WHERE gene_id      = geneID
		   AND sequence_id IN(SELECT sequence_id
		                        FROM SEQUENCE
							   WHERE accession_number = table_to_receive(seq_counter));
		UPDATE SEQUENCE
		   SET is_ref_sequence = 1
		 WHERE accession_number = table_to_receive(seq_counter);
	END LOOP;
  END IF;
  EXCEPTION
	 WHEN OTHERS THEN
	  NULL;
END SET_REF_SEQ;

PROCEDURE ADD_PKC IS
  PKC_ID NUMBER;
BEGIN
  SELECT MAX(GENE_ID)+1 INTO PKC_ID FROM GENE;
  INSERT INTO GENE(GENE_ID, GENE_SYMBOL, TAXON_ID)
  VALUES (PKC_ID, 'PKC', 6);
  INSERT INTO GENE_IDENTIFIERS(GENE_ID, DATA_SOURCE, IDENTIFIER)
  VALUES (PKC_ID, 2, '50818');
END;




PROCEDURE load_unigene IS
 geneID NUMBER;
 chomosomeID NUMBER;
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE MAP REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_MAP REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_EXPRESSED_IN REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE CGAP_GENE_ALIAS REUSE STORAGE ');

   UPDATE GENE SET cluster_id =
           (SELECT identifier FROM GENE_IDENTIFIERS
             WHERE DATA_SOURCE = 1
               AND GENE_IDENTIFIERS.gene_id = GENE.gene_id);
	COMMIT;
	INSERT INTO MAP(map_location,
	                MAP_TYPE)
	     SELECT DISTINCT CYTOBAND, 'C'
	       FROM cgap.MM_CLUSTER@WEB.NCI.NIH.GOV HC
		 UNION
		 SELECT DISTINCT CYTOBAND, 'C'
	       FROM cgap.HS_CLUSTER@WEB.NCI.NIH.GOV HC;

    FOR generec IN (SELECT * FROM cgap.HS_CLUSTER@WEB.NCI.NIH.GOV) LOOP
	     SELECT MAX(G.GENE_ID) INTO geneID
		   FROM GENE G
		  WHERE cluster_id = generec.cluster_number
			AND TAXON_ID = 5;
		 IF generec.omim IS NOT NULL THEN
		    BEGIN
	          INSERT INTO GENE_IDENTIFIERS(gene_id,
	                                      identifier,
		    						  	  DATA_SOURCE)
			       VALUES(geneID,
			              generec.OMIM,
					      3);
		    EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;
		 END IF;
		IF generec.CYTOBAND IS NOT NULL THEN
		 BEGIN
		  INSERT INTO GENE_MAP(map_id, gene_id)
		  SELECT DISTINCT map_id, geneID
		    FROM MAP
		   WHERE map_location = generec.CYTOBAND
		     AND MAP_TYPE = 'C';
		   EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;
		END IF;

		IF generec.sequences IS NOT NULL THEN
          set_ref_seq(generec.sequences, geneID);
		END IF;
        COMMIT;
	END LOOP;
    FOR generec IN (SELECT * FROM cgap.MM_CLUSTER@WEB.NCI.NIH.GOV) LOOP
	     SELECT MAX(G.GENE_ID) INTO geneID
		   FROM GENE G
		  WHERE cluster_id = generec.cluster_number
			AND TAXON_ID = 6;
		 IF generec.omim IS NOT NULL THEN
		    BEGIN
	          INSERT INTO GENE_IDENTIFIERS(gene_id,
	                                      identifier,
		    						  	  DATA_SOURCE)
			       VALUES(geneID,
			              generec.OMIM,
					      3);
		    EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;
		 END IF;
		IF generec.CYTOBAND IS NOT NULL THEN
		  BEGIN
		     INSERT INTO GENE_MAP(gene_id, map_id)
		     SELECT map_id, geneID
		       FROM MAP
		      WHERE map_location = generec.CYTOBAND
		        AND MAP_TYPE = 'C';
		    EXCEPTION
		  	WHEN OTHERS THEN
			  INSERT INTO ERRORS(error_value) VALUES('cytoband-' || generec.CYTOBAND || ':' || 'geneID' || geneID);
		    END;
		END IF;

		IF generec.sequences IS NOT NULL THEN
          set_ref_seq(generec.sequences, geneID);
		END IF;
        COMMIT;
	END LOOP;

    INSERT INTO GENE_EXPRESSED_IN(gene_id,
	                              organ_id)
	     SELECT G.gene_id, TISSUE_CODE
	       FROM GENE G,
			    CGAP.HS_GENE_TISSUE@WEB.NCI.NIH.GOV HGT
		  WHERE CLUSTER_ID = HGT.CLUSTER_NUMBER
			AND G.TAXON_ID = 5;
COMMIT;
    INSERT INTO GENE_EXPRESSED_IN(gene_id,
	                              organ_id)
	     SELECT G.gene_id, TISSUE_CODE
	       FROM GENE G,
			    CGAP.MM_GENE_TISSUE@WEB.NCI.NIH.GOV MGT
		  WHERE CLUSTER_ID = MGT.CLUSTER_NUMBER
			AND G.TAXON_ID = 6;
COMMIT;
    UPDATE DAS_MRNA_MAP
	   SET sequence_id = (SELECT MIN(sequence_id)
	  FROM SEQUENCE
     WHERE SEQUENCE.ACCESSION_NUMBER = DAS_MRNA_MAP.ACCESSION_NUMBER);
COMMIT;

     UPDATE GENE_IDENTIFIERS
	    SET IDENTIFIER = SUBSTR(IDENTIFIER,1,INSTR(IDENTIFIER,';')-1)
      WHERE IDENTIFIER LIKE '%;%';
     COMMIT;

	  UPDATE DAS_MRNA_MAP mrna SET sequence_id =
     (SELECT sequence_id
	    FROM SEQUENCE seq
	   WHERE mrna.accession_number = seq.accession_number);
	  COMMIT;

    EXECUTE IMMEDIATE('INSERT INTO CGAP_GENE_ALIAS(gene_id, alias)
      SELECT * FROM
       (SELECT (SELECT gene_id FROM GENE WHERE GENE.CLUSTER_ID=cGENE.CLUSTER_NUMBER AND GENE.taxon_id = 5) id,
        GENE
         FROM cgap.HS_CLUSTER@WEB.NCI.NIH.GOV cgene)
         WHERE id IS NOT NULL AND GENE IS NOT NULL');
	 COMMIT;
	 EXECUTE IMMEDIATE('INSERT INTO CGAP_GENE_ALIAS(gene_id, alias)
      SELECT * FROM
       (SELECT (SELECT gene_id FROM GENE WHERE GENE.CLUSTER_ID=cGENE.CLUSTER_NUMBER AND GENE.taxon_id = 6) id,
        GENE
         FROM cgap.MM_CLUSTER@WEB.NCI.NIH.GOV cgene)
         WHERE id IS NOT NULL AND GENE IS NOT NULL');
	 COMMIT;
   END;


PROCEDURE load_go IS

 geneID NUMBER;
 geneFlag VARCHAR(50);
BEGIN

    EXECUTE IMMEDIATE('TRUNCATE TABLE GO_ONTOLOGY REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GO_RELATIONSHIP REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_ONTOLOGY_TEMP REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GO_GENES REUSE STORAGE ');
    INSERT INTO GO_ONTOLOGY(go_id,
	                        go_name,
	                        hs_genes,
				mm_genes)
SELECT a.go_id, a.go_name, hs_count, mm_count FROM (
SELECT g.go_id, g.go_name, NVL (COUNT (UNIQUE c.cluster_number), 0) hs_count
FROM   CGAP.GO_NAME@WEB.NCI.NIH.GOV g,
       CGAP.LL_GO@WEB.NCI.NIH.GOV l,
       CGAP.hs_cluster@WEB.NCI.NIH.GOV c
WHERE  g.go_id = l.go_id (+)
  AND  l.ll_id = c.locuslink (+)
GROUP BY g.go_id, g.go_name) a,
(SELECT g.go_id, g.go_name, NVL (COUNT (UNIQUE c.cluster_number), 0) MM_count
FROM   CGAP.GO_NAME@WEB.NCI.NIH.GOV g,
       CGAP.LL_GO@WEB.NCI.NIH.GOV l,
       CGAP.MM_cluster@WEB.NCI.NIH.GOV c
WHERE  g.go_id = l.go_id (+)
  AND  l.ll_id = c.locuslink (+)
GROUP BY g.go_id, g.go_name) b
WHERE a.go_id = b.go_id;

    COMMIT;

    INSERT INTO GO_RELATIONSHIP (child_id,
	                        parent_id,
				relationship)
		SELECT DISTINCT go_id,
	                        go_parent_ID,
				PARENT_TYPE
		  FROM CGAP.GO_PARENT@WEB.NCI.NIH.GOV;

    COMMIT;

	INSERT INTO GENE_ONTOLOGY_TEMP(GO_ID,
                                   ORGANISM,
                                   LOCUS_ID)
         SELECT   TO_NUMBER(GO_ID) GO_ID,
                  DECODE(organism, 'Hs', 5, 'Mm', 6) ORGANISM,
                  LL_ID
		 FROM  CGAP.LL_GO@WEB.NCI.NIH.GOV;

      INSERT INTO GO_GENES(gene_id,
	                       go_id,
						   taxon_id)
	  SELECT gene_id,
	         go_id,
			 organism
	   FROM  GENE_ONTOLOGY_TEMP GOT,
	         GENE_IDENTIFIERS GI
	  WHERE  GI.IDENTIFIER = GOT.LOCUS_ID
	    AND  GI.DATA_SOURCE = 2;
	 COMMIT;
	 Load_Heir.MAKECLOSURE;
   EXCEPTION
    WHEN OTHERS THEN
	 NULL;
END;


PROCEDURE Load_Pathways IS
 pathFlag NUMBER;
 pathwayID NUMBER;
 geneID NUMBER;
 geneFlag VARCHAR(50);
BEGIN
	EXECUTE IMMEDIATE('TRUNCATE TABLE BIOGENES_TEMP REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_PATHWAY REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE BIOGENES REUSE STORAGE ');
    FOR pathrec IN (SELECT DISTINCT PATHWAY_NAME,
	                                pathway_display,
									DECODE(organism, 'Hs', 5, 'Mm', 6) taxon_id
					  FROM cgap.BIOPATHS@WEB.NCI.NIH.GOV) LOOP
	     SELECT COUNT(*) INTO pathFlag
		   FROM BIO_PATHWAYS
		  WHERE PATHWAY_NAME = pathrec.PATHWAY_NAME
			AND TAXON     = pathrec.taxon_id;
		 IF pathFlag = 0 THEN
		    BEGIN
			  SELECT NVL(MAX(pathway_id), 0) + 1 INTO pathwayID FROM BIO_PATHWAYS;
	          INSERT INTO BIO_PATHWAYS(pathway_id ,
	                                   PATHWAY_NAME,
		    						   pathway_display,
									   TAXON)
			       VALUES(pathwayID,
			              pathrec.PATHWAY_NAME,
						  pathrec.pathway_display,
					      pathrec.taxon_id);
		    EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;
	     ELSE
		    BEGIN
	          UPDATE BIO_PATHWAYS SET  pathway_display = pathrec.pathway_display
			   WHERE PATHWAY_NAME = pathrec.PATHWAY_NAME
			     AND TAXON        = pathrec.taxon_id;
		    EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;

		 END IF;
	END LOOP;
	 INSERT INTO BIOGENES_TEMP   SELECT DISTINCT PATHWAY_NAME,
	                                    DECODE(BIOG.organism, 'Hs', BIOG.bc_id, 'Mm', 'Mm.' || BIOG.bc_id),
										locus_id,
									    DECODE(BIOG.organism, 'Hs', 5, 'Mm', 6) taxon_id
					  FROM cgap.BIOPATHS@WEB.NCI.NIH.GOV BIOP,
					       cgap.BIOGENES@WEB.NCI.NIH.GOV BIOG
		   	         WHERE BIOG.bc_id = BIOP.bc_id(+)
					   AND BIOG.organism = BIOP.organism;
            INSERT INTO BIOGENES(bc_id ,
	                             locus_id,
								 organism,
		    					 gene_id)
			 SELECT DISTINCT bc_id,
				             locus_id,
						     taxon_id,
						     gene_ID
				FROM BIOGENES_TEMP BT,
				     GENE_IDENTIFIERS GI
			   WHERE BT.LOCUS_ID = GI.IDENTIFIER(+)
			     AND GI.DATA_SOURCE(+) = 2;

			   INSERT INTO GENE_PATHWAY(pathway_id,
			                            bc_id)
			   SELECT DISTINCT pathway_ID,
				              bc_id
			    FROM  BIO_PATHWAYS BP,
				      BIOGENES_TEMP BG
			   WHERE  BP.PATHWAY_NAME = BG.PATHWAY_NAME
			     AND  BP.TAXON        = BG.TAXON_ID
				 AND  BG.PATHWAY_NAME IS NOT NULL;
			COMMIT;
		    EXCEPTION
			 WHEN OTHERS THEN
			  NULL;
		    END;


PROCEDURE load_homologues IS
BEGIN
	EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_HOMOLOGUE_REFERENCE REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_HOMOLOGUE REUSE STORAGE ');
     INSERT INTO GENE_HOMOLOGUE_REFERENCE(GENE_ID, RELATED_GENE, URL_OF_SOURCE)
          SELECT g.gene_id hs_id,
                 g2.gene_id mm_id,
	             MAX(similarity)
	         FROM GENE g,
                  GENE g2,
                  cgap.HS_TO_MM@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity LIKE 'http%'
			 GROUP BY g.gene_id,
                      g2.gene_id;
	 COMMIT;
     INSERT INTO GENE_HOMOLOGUE(GENE_ID, RELATED_GENE, PERCENT_ALIGNMENT)
          SELECT DISTINCT g.gene_id hs_id,
                 g2.gene_id mm_id,
	             MAX(similarity)
	         FROM GENE g,
                  GENE g2,
                  cgap.HS_TO_MM@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity NOT LIKE 'http%'
			  GROUP BY g.gene_id,
                       g2.gene_id;
	 COMMIT;
     INSERT INTO GENE_HOMOLOGUE_REFERENCE(GENE_ID, RELATED_GENE, URL_OF_SOURCE)
          SELECT DISTINCT g2.gene_id hs_id,
                 g.gene_id mm_id,
	             MAX(similarity)
	         FROM GENE g,
                  GENE g2,
                  cgap.MM_TO_HS@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity LIKE 'http%'
			 GROUP BY g.gene_id,
                      g2.gene_id;
	 COMMIT;
     INSERT INTO GENE_HOMOLOGUE(GENE_ID, RELATED_GENE, PERCENT_ALIGNMENT)
          SELECT DISTINCT g2.gene_id hs_id,
                 g.gene_id mm_id,
	             MAX(similarity)
	         FROM GENE g,
                  GENE g2,
                  cgap.MM_TO_HS@WEB.NCI.NIH.GOV gh
            WHERE g.cluster_id = gh.hs_cluster_number
              AND g.taxon_id = 5
              AND g2.cluster_id = gh.mm_cluster_number
              AND g2.taxon_id = 6
              AND similarity NOT LIKE 'http%'
			 GROUP BY g.gene_id,
                      g2.gene_id;
	 COMMIT;
	END;




PROCEDURE load_protein_homologues IS
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE PROTEIN_HOMOLOGUE REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE PROTEIN REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE PROTEIN_HOMOLOGUE_TEMP REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_PROTEIN REUSE STORAGE ');
	INSERT INTO PROTEIN_HOMOLOGUE_TEMP(CLUSTER_NUMBER,
	                                   TAXON_ID,
	                                   GI,
									   PROTID,
									   ORGANISM_ID,
									   PCT,
                                       ALN )
    SELECT CLUSTER_NUMBER,
		         DECODE(SUBSTR(BUILD_ID, 1, 1), 1, 5, 2, 6),
		         GI,
                 PROTID,
                 DECODE(ORGANISM_ID, 1, 5, 2, 6, 3, 75, 4, 77, 5, 74, 6, 76, 7, 78, 8, 79, 9, 80, 10 ,76),
				 PCT,
                 ALN
	        FROM RFLP.UG_PROTSIM@WEB.NCI.NIH.GOV;

     INSERT INTO PROTEIN(PROTEIN_ID,
	                     GENE_INFO_ID,
						 PROTEIN_INFO_ID,
						 TAXON_ID )
          SELECT DISTINCT PROTEIN_ID,
		                  PROTID,
		                  GI,
                          ORGANISM_ID
	        FROM PROTEIN_HOMOLOGUE_TEMP;
	 COMMIT;

     INSERT INTO GENE_PROTEIN (GENE_ID,
	                           PROTEIN_ID)
	 SELECT GENE_ID,
	        PROTEIN_ID
	  FROM  GENE,
	        PROTEIN_HOMOLOGUE_TEMP
	 WHERE  GENE.CLUSTER_ID = PROTEIN_HOMOLOGUE_TEMP.CLUSTER_NUMBER
	   AND  GENE.TAXON_ID   = PROTEIN_HOMOLOGUE_TEMP.ORGANISM_ID;

     COMMIT;
    INSERT INTO PROTEIN_HOMOLOGUE (PROTEIN_ID,
	                               RELATED_PROTEIN,
                                   PERCENT_ALIGNMENT,
								   ALIGN_LENGTH)
	SELECT  GENE_PROTEIN.PROTEIN_ID GP_PROTIEN_ID,
	        PROTEIN_HOMOLOGUE_TEMP.PROTEIN_ID RELATED_PROTEIN_ID,
			PCT,
			ALN
	  FROM  GENE,
	        GENE_PROTEIN,
	        PROTEIN_HOMOLOGUE_TEMP
	 WHERE  GENE.CLUSTER_ID = PROTEIN_HOMOLOGUE_TEMP.CLUSTER_NUMBER
       AND  GENE.GENE_ID = GENE_PROTEIN.GENE_ID;
	END;
PROCEDURE load_targets IS
BEGIN
  EXECUTE IMMEDIATE('TRUNCATE TABLE GENE_TARGET REUSE STORAGE ');
    ADD_PKC;
    INSERT INTO GENE_TARGET(TARGET_ID, GENE_ID)
    SELECT TARGET.TARGET_ID,
	       GENE_IDENTIFIERS.GENE_ID
	  FROM TARGET, GENE_IDENTIFIERS
	 WHERE DATA_SOURCE = 2
	   AND GENE_IDENTIFIERS.IDENTIFIER = LOCUS_ID;
END;

PROCEDURE fix_sequences IS
    first_time BOOLEAN := TRUE;
    save_sequence NUMBER;
BEGIN

     UPDATE GENE_SEQUENCE gene_seq
	    SET sequence_id = (SELECT MIN(sequence_id)
		                     FROM SEQUENCE
						    WHERE SEQUENCE.ACCESSION_NUMBER IN (SELECT accession_number
                                                                  FROM SEQUENCE SEQ
															     WHERE SEQ.sequence_id = gene_seq.sequence_id));
 FOR acc_rec IN( SELECT /*+ INDEX(SEQUENCE_ACCESSION_IND) */
                       accession_number FROM SEQUENCE GROUP BY
                       accession_number HAVING COUNT(*)>1) LOOP
	first_time := TRUE;
	FOR seq_rec IN( SELECT * FROM SEQUENCE WHERE ACCESSION_NUMBER = acc_rec.accession_number ORDER BY SEQUENCE_ID) LOOP
	   IF first_time THEN
	      save_sequence := seq_rec.SEQUENCE_ID;
		  first_time := FALSE;
	   ELSE
		  DELETE FROM SEQUENCE WHERE sequence_id = seq_rec.sequence_id;
	   END IF;
	END LOOP;
END LOOP;
COMMIT;
END;

PROCEDURE fix_clones IS
    first_time BOOLEAN := TRUE;
    save_clone NUMBER;
BEGIN
FOR name_rec IN( SELECT /*+ INDEX(CLONE_NAME_IND) */
                       clone_name, COUNT(clone_name) FROM CLONE
					   WHERE clone_name > ' ' AND clone_name <> 'unknown'
					   GROUP BY clone_name
					   HAVING COUNT(clone_name)>1) LOOP
	first_time := TRUE;
	FOR clone_rec IN( SELECT * FROM CLONE WHERE clone_name = name_rec.clone_name) LOOP
	   IF first_time THEN
	      save_clone := clone_rec.CLONE_ID;
		  first_time := FALSE;
	   ELSE
	      UPDATE SEQUENCE SET clone_id = save_clone WHERE clone_id = clone_rec.clone_id;
		  DELETE FROM CLONE WHERE clone_id = clone_rec.clone_id;
	   END IF;
	   COMMIT;
	END LOOP;
END LOOP;

	COMMIT;
     UPDATE CLONE
	    SET library_id = (SELECT MIN(library_id) FROM LIBRARY
                           WHERE LIBRARY.UNIGENE_ID = CLONE.UNIGENE_LIBRARY);
    COMMIT;
END;

PROCEDURE load_cmap IS
geneID NUMBER;
BEGIN
  /**  EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_GENES REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_AGENTS REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_TARGETS REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_TARGETAGENTS REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_IDS REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE CMAP_NAMES REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE ONTOLOGY_RELATIONSHIP REUSE STORAGE ');
	FOR generec IN (SELECT cmap_g.gene_id,
		                   gene_name
	                  FROM CMAP.CMAP_GENES@WEB.NCI.NIH.GOV CMAP_G,
			               GENE_IDENTIFIERS
		              WHERE DATA_SOURCE(+) = 2
		                AND GENE_IDENTIFIERS.identifier(+) = CMAP_G.gene_id
						AND GENE_IDENTIFIERS.gene_id IS NULL) LOOP
			SELECT MAX(GENE_ID) + 1 INTO geneID FROM GENE ;
			INSERT INTO GENE(gene_id,
			                 gene_symbol)
			VALUES(geneID,
			       generec.gene_name);
			INSERT INTO GENE_IDENTIFIERS(gene_id,
			                             identifier,
										 DATA_SOURCE)
			VALUES (geneID,
			        generec.gene_id,
				    2);
			COMMIT;
		END LOOP;

 		INSERT INTO CMAP_GENES(gene_id,
							   gene_name)
          SELECT GENE_IDENTIFIERS.gene_id,
		         gene_name
	        FROM CMAP.CMAP_GENES@WEB.NCI.NIH.GOV CMAP_G,
			     GENE_IDENTIFIERS
		   WHERE DATA_SOURCE = 2
		     AND GENE_IDENTIFIERS.identifier = CMAP_G.gene_id;

		INSERT INTO CMAP_AGENTS(agent_id,
                                agent_name,
                                agent_source,
                                agent_comment)
		SELECT SUBSTR(agent_id, 3),
               agent_name,
               agent_source,
               agent_comment
		  FROM  CMAP.CMAP_AGENTS@WEB.NCI.NIH.GOV;

		INSERT INTO CMAP_TARGETS(target_id,
                                 gene_id,
								 ANOMALY,
                                 cancer_type)
		SELECT SUBSTR(target_id, 3),
               GENE_IDENTIFIERS.gene_id,
               ANOMALY,
               cancer_type
		  FROM CMAP.CMAP_TARGETS@WEB.NCI.NIH.GOV CMAP_T,
			   GENE_IDENTIFIERS
		 WHERE DATA_SOURCE = 2
		    AND GENE_IDENTIFIERS.identifier = CMAP_T.gene_id;

		INSERT INTO CMAP_TARGETAGENTS(target_id,
		                              agent_id)
		SELECT SUBSTR(target_id, 3),
		       SUBSTR(agent_id, 3)
		  FROM CMAP.CMAP_TARGETAGENTS@WEB.NCI.NIH.GOV CMAP_T;

 		INSERT INTO CMAP_NAMES(cmap_id,
		                       cmap_name)
		SELECT DISTINCT cmap_id,
		                cmap_name
		  FROM CMAP.CMAP_NAMES@WEB.NCI.NIH.GOV CMAP_T;

		INSERT INTO CMAP_IDS(cmap_id,
		                     gene_id)
		SELECT cmap_id,
		       GENE_IDENTIFIERS.gene_id
		  FROM CMAP.CMAP_IDS@WEB.NCI.NIH.GOV CMAP_I,
			   GENE_IDENTIFIERS
		 WHERE DATA_SOURCE = 2
		    AND GENE_IDENTIFIERS.identifier = CMAP_I.locus_id;

 		INSERT INTO ONTOLOGY_RELATIONSHIP(parent_id,
		                                  child_id,
										  relationship)
		SELECT DISTINCT cmap_parent,
		                cmap_id,
			           'part-OF' rel
		  FROM CMAP.CMAP_NAMES@WEB.NCI.NIH.GOV;
	    COMMIT; **/
		NULL;
END load_cmap;

PROCEDURE add_histopathology(gene_id_in NUMBER, keywords VARCHAR2)
IS
 table_to_receive Pk_Genutilitypkg.t_string;
 keyword_counter NUMBER;
 found_histology NUMBER := -100;
 found_tissue NUMBER := -100;
 found_context NUMBER := -100;
 found_gene_histo NUMBER;
BEGIN
     Pk_Genutilitypkg.sp_parsestring (
      keywords,
      ',',
      table_to_receive
      );
	  FOR keyword_counter IN 1 .. table_to_receive.COUNT LOOP
	    IF found_histology = -100 THEN
	       SELECT NVL(MAX(HISTOLOGY_CODE), -100) INTO found_histology FROM HISTOLOGY_CODE WHERE histology_name = TRIM(table_to_receive (keyword_counter));
		END IF;
	    IF found_tissue = -100 THEN
	       SELECT NVL(MAX(TISSUE_CODE), -100) INTO found_tissue FROM TISSUE_CODE WHERE tissue_name = TRIM(table_to_receive (keyword_counter));
		END IF;
	  END LOOP;
        IF found_histology <> -100 AND found_tissue <> -100 THEN
		    SELECT NVL(MAX(CONTEXT_CODE), -100) INTO found_context
			  FROM CONTEXT
			 WHERE TISSUE_CODE = found_tissue
			   AND HISTOLOGY_CODE = found_histology;
			IF found_context = -100 THEN
			   SELECT MAX(context_code) + 1 INTO found_context FROM CONTEXT;
			   INSERT INTO CONTEXT(CONTEXT_CODE, TISSUE_CODE, HISTOLOGY_CODE)
			        VALUES (found_context, found_tissue, found_histology);
			END IF;
		    SELECT COUNT(*) INTO found_gene_histo
			   FROM GENE_HISTOPATHOLOGY
			  WHERE gene_id = gene_id_in
			    AND context_code = found_context;
		    IF found_gene_histo = 0 THEN
		       INSERT INTO GENE_HISTOPATHOLOGY(gene_id,
		                                       context_code)
				 VALUES(gene_id_in,
				        found_context);
			END IF;
		 END IF;

END add_histopathology;


PROCEDURE load_tissues_and_histologies IS
  CURRENT_CLUSTER NUMBER := -1;
  CURRENT_GENE NUMBER;
BEGIN

  FOR GENE_CUR IN (SELECT cluster_number, keyword FROM cgap.hs_est@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                   WHERE gl.library_id = l.library_id
                     AND ORG = 'Hs'
                  UNION ALL
                  SELECT cluster_number, keyword FROM cgap.HS_SAGE@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                  WHERE gl.library_id  = l.library_id
                    AND ORG = 'Hs') LOOP
       IF CURRENT_CLUSTER <> GENE_CUR.CLUSTER_NUMBER THEN
	      SELECT NVL(MAX(GENE_ID), -100) INTO CURRENT_GENE FROM GENE WHERE TAXON_ID = 5 AND CLUSTER_ID = GENE_CUR.CLUSTER_NUMBER;
       END IF;
	   IF CURRENT_GENE <> -100 THEN
	       add_histopathology(CURRENT_GENE, GENE_CUR.KEYWORD);
		   COMMIT;
	   END IF;
  END LOOP;
  FOR GENE_CUR IN (SELECT cluster_number, keyword FROM cgap.mm_est@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                   WHERE gl.library_id  = l.library_id
                     AND ORG = 'Mm'
                  UNION ALL
                  SELECT cluster_number, keyword FROM cgap.mm_sage@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                  WHERE gl.library_id  = l.library_id
                    AND ORG = 'Mm') LOOP
       IF CURRENT_CLUSTER <> GENE_CUR.CLUSTER_NUMBER THEN
	      SELECT NVL(MAX(GENE_ID), -100) INTO CURRENT_GENE FROM GENE WHERE TAXON_ID = 6 AND CLUSTER_ID = GENE_CUR.CLUSTER_NUMBER;
       END IF;
	   IF CURRENT_GENE <> -100 THEN
	       add_histopathology(CURRENT_GENE, GENE_CUR.KEYWORD);
		   COMMIT;
	   END IF;
  END LOOP;
END;
PROCEDURE load_tissues_and_histo_mouse IS
  CURRENT_CLUSTER NUMBER := -1;
  CURRENT_GENE NUMBER;
BEGIN

  FOR GENE_CUR IN (SELECT cluster_number, keyword FROM cgap.mm_est@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                   WHERE gl.library_id  = l.library_id
                     AND ORG = 'Mm'
                  UNION ALL
                  SELECT cluster_number, keyword FROM cgap.mm_sage@WEB.NCI.NIH.GOV gl, cgap.all_libraries@WEB.NCI.NIH.GOV l
                  WHERE gl.library_id  = l.library_id
                    AND ORG = 'Mm') LOOP
       IF CURRENT_CLUSTER <> GENE_CUR.CLUSTER_NUMBER THEN
	      SELECT NVL(MAX(GENE_ID), -100) INTO CURRENT_GENE FROM GENE WHERE TAXON_ID = 6 AND CLUSTER_ID = GENE_CUR.CLUSTER_NUMBER;
       END IF;
	   IF CURRENT_GENE <> -100 THEN
	       add_histopathology(CURRENT_GENE, GENE_CUR.KEYWORD);
		   COMMIT;
	   END IF;
  END LOOP;
END;
PROCEDURE LOAD_SNPS IS
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE ACE REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE LOCATION REUSE STORAGE ');
    EXECUTE IMMEDIATE('TRUNCATE TABLE SNPSEQ REUSE STORAGE ');
	EXECUTE IMMEDIATE('TRUNCATE TABLE SNP2UNIQ REUSE STORAGE ');
  --  EXECUTE IMMEDIATE('TRUNCATE TABLE CLONE_TRACE REUSE STORAGE ');
	EXECUTE IMMEDIATE('INSERT INTO ACE(ACE_ID,
                       FILENAME,
                       PROJECT_ID,
                       SUBSET_ID,
                       ACCESSION,
                       CLUSTER_NUMBER,
                       IS_TOPLEVEL,
                       GENE_ID)
	SELECT 	  ACE_ID,
              FILENAME,
              PROJECT_ID,
              SUBSET_ID,
              ACCESSION,
              CLUSTER_NUMBER,
              IS_TOPLEVEL,
			  (SELECT MAX(gene_id) FROM GENE WHERE cluster_id = cluster_number AND taxon_id = 5 )
     FROM rflp.ACE@WEB.NCI.NIH.GOV');
	 COMMIT;
	INSERT INTO LOCATION( LOCATION_ID,
                          ACE_ID,
                          CONTIG,
                          OFFSET,
                          SCORE,
                          BASE1,
                          BASE2)
		SELECT	LOCATION_ID,
                ACE_ID,
                CONTIG,
                OFFSET,
                SCORE,
                BASE1,
                BASE2
	FROM Rflp.LOCATION@WEB.NCI.NIH.GOV;
	 COMMIT;
	EXECUTE IMMEDIATE('INSERT INTO SNP2UNIQ(SNP_ID,
                                            ACCESSION,
                                            HS,
                                            BUILD_ID,
                                            GENE_ID)
	               SELECT SNP_ID,
                          ACCESSION,
                          HS,
                          BUILD_ID,
			             (SELECT MAX(gene_id) FROM GENE WHERE cluster_id = HS AND taxon_id = 5 ) TTT
	                FROM Rflp.SNP2UNIQ@WEB.NCI.NIH.GOV
	               WHERE BUILD_ID = (SELECT MAX(BUILD_ID) FROM Rflp.SNP2UNIQ@WEB.NCI.NIH.GOV)');
	 COMMIT;
	INSERT INTO SNPSEQ(LOCATION_ID,
                       TRACE,
                       BASE,
                       QUALITY)
	SELECT LOCATION_ID,
           TRACE,
           BASE,
           QUALITY
	 FROM Rflp.SNPSEQ@WEB.NCI.NIH.GOV;
	 COMMIT;
 END;
 PROCEDURE load_dc IS
 BEGIN
    -- LOAD DC IS DEPRICATED WITH THE END OF GEDP
	NULL;
END;
END; 
/

