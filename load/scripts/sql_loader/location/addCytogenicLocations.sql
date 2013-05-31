/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--COMMIT;
VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM location_ch; 

ANALYZE TABLE cytogenic_location_cytoband COMPUTE STATISTICS;
ANALYZE TABLE zstg_array_reporter_ch COMPUTE STATISTICS;

INSERT
  INTO location_ch (ID, CYTO_SNP_ID, START_cytoband_LOC_ID, END_CYTOBAND_LOC_ID, 
chromosome_ID, BIG_ID, DISCRIMINATOR) SELECT DISTINCT B.CYTOGENIC_LOCATION_ID, 
      B.SNP_ID, B.START_cytoband_LOC_ID, B.END_CYTOBAND_LOC_ID, B.chromosome_ID, 
                             B.BIG_ID, 'SNPCytogeneticLocation' AS DISCRIMINATOR
                                        FROM cytogenic_location_cytoband B
                                       WHERE B.SNP_ID IS NOT NULL;
COMMIT;

INSERT
 INTO location_ch (ID, CYTO_gene_ID, START_cytoband_LOC_ID, END_CYTOBAND_LOC_ID, 
chromosome_ID, BIG_ID, DISCRIMINATOR) SELECT DISTINCT B.CYTOGENIC_LOCATION_ID, 
     B.gene_ID, B.START_cytoband_LOC_ID, B.END_CYTOBAND_LOC_ID, B.chromosome_ID, 
                            B.BIG_ID, 'GeneCytogeneticLocation' AS DISCRIMINATOR
                                        FROM cytogenic_location_cytoband B
                                       WHERE B.gene_ID IS NOT NULL;
COMMIT;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM location_ch; 

INSERT
  INTO location_ch (ID, CYTO_REPORTER_ID, START_cytoband_LOC_ID, 
END_cytoband_LOC_ID, chromosome_ID, DISCRIMINATOR, ASSEMBLY) SELECT 
           DISTINCT ROWNUM + &V_MAXROW, B.ORIG_ID, B.START_CYTOID, B.END_CYTOID, 
 B.chromosome_ID, 'ArrayReporterCytogeneticLocation' AS DISCRIMINATOR, 
                                                                      B.ASSEMBLY
                                                   FROM zstg_array_reporter_ch B
WHERE B.chromosome_ID IS NOT NULL AND (START_CYTOID IS NOT NULL OR END_CYTOID IS 
NOT NULL);
COMMIT;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM location_ch; 

INSERT
  INTO location_ch (ID, array_reporter_ID, CHROMOSOMAL_START_POSITION, 
CHROMOSOMAL_END_POSITION, chromosome_ID, DISCRIMINATOR, ASSEMBLY) SELECT 
DISTINCT ROWNUM + &V_MAXROW, B.ORIG_ID, B.CHR_START, B.CHR_STOP, B.chromosome_ID
        , 'ArrayReporterPhysicalLocation' AS DISCRIMINATOR, B.ASSEMBLY
                                                   FROM zstg_array_reporter_ch B
WHERE B.chromosome_ID IS NOT NULL AND (B.CHR_START IS NOT NULL AND B.CHR_STOP IS 
NOT NULL);

COMMIT;

exit;
