CREATE OR REPLACE PACKAGE Load_Data AS
  PROCEDURE load_libraries;
  PROCEDURE load_go;
  FUNCTION  get_taxon(taxon_abbr VARCHAR2, strain_name VARCHAR2) RETURN NUMBER;
END; 
/
CREATE OR REPLACE PACKAGE BODY Load_Data AS
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
		COMMIT;	
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
	         GENE_IDENTIFIERS_STG31 GI
	  WHERE  GI.IDENTIFIER = GOT.LOCUS_ID
	    AND  GI.DATA_SOURCE = 2;
	 COMMIT;
	 Load_Heir.MAKECLOSURE;
   EXCEPTION
    WHEN OTHERS THEN
	 NULL;
END;

END; 
/

