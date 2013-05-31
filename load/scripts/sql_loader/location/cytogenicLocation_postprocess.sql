/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/cytogenic_location_cytoband.cols.sql;
@$LOAD/indexes/cytogenic_location_cytoband.lower.sql;

ANALYZE TABLE cytogenic_location_cytoband COMPUTE STATISTICS;
INSERT
  INTO location_tv (ID, gene_ID, NUCLEIC_ACID_ID, SNP_ID, chromosome_ID) SELECT 
      DISTINCT CYTOGENIC_LOCATION_ID, gene_ID, nucleic_acid_sequence_ID, SNP_ID, 
                                                                   chromosome_ID
                                               FROM cytogenic_location_cytoband;

COMMIT;
@$LOAD/constraints/cytogenic_location_cytoband.enable.sql;

EXIT; 
