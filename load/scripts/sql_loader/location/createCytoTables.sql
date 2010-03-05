DROP TABLE zstg_startcytoids;
DROP TABLE zstg_endcytoids;
DROP TABLE zstg_snpcytoids;
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
column columnload new_value load_tablspc;
select globals.get_load_tablespace as columnload from dual;
CREATE TABLE zstg_startcytoids TABLESPace &load_tablspc AS SELECT DISTINCT gene_ID, 
                                             START_cytoband, ID, A.chromosome_ID
                                                    FROM zstg_gene A, cytoband B
WHERE TRIM(LOWER(A.START_cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID = 
                                                             B.chromosome_ID;

CREATE TABLE zstg_endcytoids TABLESPace &load_tablspc AS SELECT DISTINCT gene_ID, 
                                               END_cytoband, ID, A.chromosome_ID
                                                    FROM zstg_gene A, cytoband B
  WHERE TRIM(LOWER(A.END_cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome_ID = 
                                                           B.chromosome_ID;

CREATE TABLE zstg_snpcytoids TABLESPace &load_tablspc AS SELECT DISTINCT 
                                A.DBSNP_RS_ID, A.cytoband, B.ID, C.chromosome_ID
                                  FROM zstg_snp_affy A, cytoband B, chromosome C
         WHERE TRIM(LOWER(A.cytoband)) = TRIM(LOWER(B.NAME)) AND A.chromosome = 
C.chromosome_NUMBER AND C.CHROMOSOME_ID = B.CHROMOSOME_ID AND A.DBSNP_RS_ID NOT 
                                                           LIKE '%-%';


CREATE INDEX START1 ON zstg_startcytoids(START_cytoband) TABLESPace &load_tablspc;
CREATE INDEX START2 ON zstg_startcytoids(gene_ID) TABLESPace &load_tablspc;
CREATE INDEX START3 ON zstg_startcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX START4 ON zstg_startcytoids(chromosome_ID) TABLESPace &load_tablspc;
CREATE INDEX END1 ON zstg_endcytoids(END_cytoband) TABLESPace &load_tablspc;
CREATE INDEX END2 ON zstg_endcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX END3 ON zstg_endcytoids(gene_ID) TABLESPace &load_tablspc;
CREATE INDEX END4 ON zstg_endcytoids(chromosome_ID) TABLESPace &load_tablspc;
CREATE INDEX STARTSNP1 ON zstg_snpcytoids(DBSNP_RS_ID) TABLESPace &load_tablspc;
CREATE INDEX STARTSNP2 ON zstg_snpcytoids(cytoband) TABLESPace &load_tablspc;
CREATE INDEX STARTSNP3 ON zstg_snpcytoids(ID) TABLESPace &load_tablspc;
CREATE INDEX STARTSNP4 ON zstg_snpcytoids(chromosome_ID) TABLESPace &load_tablspc;

exit;
