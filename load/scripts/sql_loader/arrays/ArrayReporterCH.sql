TRUNCATE TABLE array_reporter_ch REUSE STORAGE;
TRUNCATE TABLE zstg_array_reporter_ch REUSE STORAGE;
@$LOAD/indexer_new.sql zstg_array_reporter_ch
@$LOAD/indexer_new.sql array_reporter_ch
@$LOAD/constraints.sql zstg_array_reporter_ch
@$LOAD/constraints.sql array_reporter_ch
@$LOAD/constraints/zstg_array_reporter_ch.disable.sql
@$LOAD/constraints/array_reporter_ch.disable.sql
@$LOAD/indexes/zstg_array_reporter_ch.drop.sql
@$LOAD/indexes/array_reporter_ch.drop.sql

@createCytoArrayTables.sql
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
INSERT
  INTO zstg_array_reporter_ch (ID, NAME, microarray_ID, MANUFACTURER_PSR_ID,
PROBE_COUNT, STRAND, transcript_ID, exon_ID, DISCRIMINATOR, BIG_ID,
chromosome_ID, CHR_START, CHR_STOP, ORIG_ID) SELECT DISTINCT A.ID, A.NAME,
A.microarray_ID, A.MANUFACTURER_PSR_ID, A.PROBE_COUNT, A.STRAND, A.transcript_ID
                                                    ,
     A.exon_ID, 'ExonArrayReporter' AS DISCRIMINATOR, B.BIG_ID, A.chromosome_ID,
                                         A.START_LOCATION, A.STOP_LOCATION, B.ID
                                      FROM zstg_exon_reporter A, exon_reporter B
                  WHERE A.NAME = B.NAME AND A.microarray_ID = B.MICROARRAY_ID; 
COMMIT;

ANALYZE TABLE zstg_expression_reporter COMPUTE STATISTICS;
INSERT
  INTO zstg_array_reporter_ch (ID, NAME, microarray_ID, sequence_type,
SEQUENCE_source, target_ID, TARGET_DESCRIPTION, gene_ID, nas_ID, chromosome_ID,
CHR_START, CHR_STOP, CYTO_START, CYTO_STOP, DISCRIMINATOR, START_CYTOID,
END_CYTOID, ASSEMBLY, BIG_ID, ORIG_ID) SELECT DISTINCT A.ID, A.NAME,
           A.microarray_ID, A.sequence_type, A.SEQUENCE_source, A.transcript_ID,
        A.target_DESCRIPTION, A.gene_ID, A.nas_ID, A.chromosome_ID, A.CHR_START,
             A.CHR_STOP, A.CYTO_START, A.CYTO_STOP, 'ExpressionArrayReporter' AS 
           DISCRIMINATOR, B.cytobandID, C.CYTOBANDID, A.ASSEMBLY, D.BIG_ID, D.ID
                    FROM zstg_expression_reporter A, zstg_startexprarrayrepcytoids B,
                                 zstg_endexprarrayrepcytoids C, expression_reporter D
WHERE A.ID = B.ID(+) AND A.chromosome_ID = B.CHROMOSOME_ID(+) AND A.CYTO_START 
 = B.CYTO_START(+) AND A.ID = C.ID(+) AND A.chromosome_ID = C.CHROMOSOME_ID(+) 
   AND A.CYTO_STOP = C.CYTO_STOP(+) AND A.NAME = D.NAME AND A.microarray_ID =
                                              D.microarray_ID;
COMMIT;

ANALYZE TABLE zstg_snp_reporter COMPUTE STATISTICS;
INSERT
INTO zstg_array_reporter_ch(ID, NAME, microarray_ID, SNP_ID, PHAST_CONSERVATION,
chromosome_ID, CHR_START, CHR_STOP, CYTO_START, CYTO_STOP, DISCRIMINATOR,
START_CYTOID, END_CYTOID, BIG_ID, ORIG_ID) SELECT DISTINCT A.ID, A.NAME,
  A.microarray_ID, A.SNP_ID, A.PHAST_CONSERVATION, A.chromosome_ID, A.CHR_START,
     A.CHR_STOP, A.CYTO_START, A.CYTO_STOP, 'SNPArrayReporter' AS DISCRIMINATOR,
                                      B.cytobandID, C.CYTOBANDID, D.BIG_ID, D.ID
            FROM snp_reporter D, zstg_snp_reporter A, zstg_startsnparrayrepcytoids B,
                                                  zstg_endsnparrayrepcytoids C
WHERE A.ID = B.ID(+) AND A.chromosome_ID = B.CHROMOSOME_ID(+) AND A.CYTO_START 
 = B.CYTO_START(+) AND A.ID = C.ID(+) AND A.chromosome_ID = C.CHROMOSOME_ID(+) 
   AND A.CYTO_STOP = C.CYTO_STOP(+) AND A.NAME = D.NAME AND A.microarray_ID =
                                                  D.microarray_ID; 
COMMIT;

@$LOAD/indexes/zstg_array_reporter_ch.cols.sql
ANALYZE TABLE zstg_array_reporter_ch COMPUTE STATISTICS;

INSERT
  INTO array_reporter_ch(ID, NAME, microarray_ID, DISCRIMINATOR, sequence_type,
SEQUENCE_source, target_ID, TARGET_DESCRIPTION, PHAST_CONSERVATION,
MANUFACTURER_PSR_ID, PROBE_COUNT, STRAND, SNP_ID, nas_ID, gene_ID, transcript_ID
,
  exon_ID, BIG_ID) SELECT DISTINCT A.ORIG_ID, A.NAME, A.microarray_ID,
               A.DISCRIMINATOR, A.sequence_type, A.SEQUENCE_source, A.target_ID,
A.target_DESCRIPTION, A.PHAST_CONSERVATION, A.MANUFACTURER_PSR_ID, A.PROBE_COUNT
                          ,
   A.STRAND, A.SNP_ID, A.nas_ID, A.gene_ID, A.transcript_ID, A.exon_ID, A.BIG_ID
                     FROM zstg_array_reporter_ch A; 
COMMIT;
CREATE INDEX AR_REP_CH_BIGID ON array_reporter_ch(BIG_ID) TABLESPace &prod_tablspc;
CREATE INDEX AR_REP_CH_BIGID_LWR ON array_reporter_ch(LOWER(BIG_ID)) TABLESPace 
&prod_tablspc;
@$LOAD/indexes/array_reporter_ch.cols.sql
@$LOAD/indexes/array_reporter_ch.lower.sql
@$LOAD/constraints/zstg_array_reporter_ch.enable.sql
@$LOAD/constraints/array_reporter_ch.enable.sql
ANALYZE TABLE array_reporter_ch COMPUTE STATISTICS;
exit;
