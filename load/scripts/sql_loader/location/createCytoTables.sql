DROP TABLE STARTCYTOIDS;
DROP TABLE ENDCYTOIDS;
DROP TABLE SNPCYTOIDS;

CREATE TABLE STARTCYTOIDS TABLESPace cabio_map_fut AS SELECT DISTINCT gene_ID, 
                                             START_cytoband, ID, A.chromosome_ID
                                                    FROM zstg_gene A, cytoband B
WHERE TRIM(LOWER(A.START_cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID = 
                                                             B.chromosome_ID;

CREATE TABLE ENDCYTOIDS TABLESPace cabio_map_fut AS SELECT DISTINCT gene_ID, 
                                               END_cytoband, ID, A.chromosome_ID
                                                    FROM zstg_gene A, cytoband B
  WHERE TRIM(LOWER(A.END_cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID = 
                                                           B.chromosome_ID;

CREATE TABLE SNPCYTOIDS TABLESPace cabio_map_fut AS SELECT DISTINCT 
                                A.DBSNP_RS_ID, A.cytoband, B.ID, C.chromosome_ID
                                  FROM zstg_snp_affy A, cytoband B, chromosome C
         WHERE TRIM(LOWER(A.cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome = 
C.chromosome_NUMBER AND C.CHROMOSOME_ID = B.CHROMOSOME_ID AND A.DBSNP_RS_ID NOT 
                                                           LIKE '%-%';


CREATE INDEX START1 ON STARTCYTOIDS(START_cytoband) TABLESPace cabio_map_fut;
CREATE INDEX START1 ON STARTCYTOIDS(gene_ID) TABLESPace cabio_map_fut;
CREATE INDEX START2 ON STARTCYTOIDS(ID) TABLESPace cabio_map_fut;
CREATE INDEX START3 ON STARTCYTOIDS(chromosome_ID) TABLESPace cabio_map_fut;
CREATE INDEX END1 ON ENDCYTOIDS(END_cytoband) TABLESPace cabio_map_fut;
CREATE INDEX END2 ON ENDCYTOIDS(ID) TABLESPace cabio_map_fut;
CREATE INDEX END2 ON ENDCYTOIDS(gene_ID) TABLESPace cabio_map_fut;
CREATE INDEX END3 ON ENDCYTOIDS(chromosome_ID) TABLESPace cabio_map_fut;
CREATE INDEX STARTSNP1 ON SNPCYTOIDS(DBSNP_RS_ID) TABLESPace cabio_map_fut;
CREATE INDEX STARTSNP2 ON SNPCYTOIDS(cytoband) TABLESPace cabio_map_fut;
CREATE INDEX STARTSNP3 ON SNPCYTOIDS(ID) TABLESPace cabio_map_fut;
CREATE INDEX STARTSNP4 ON SNPCYTOIDS(chromosome_ID) TABLESPace cabio_map_fut;

exit;
