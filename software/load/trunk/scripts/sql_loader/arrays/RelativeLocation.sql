TRUNCATE TABLE relative_location REUSE STORAGE;
@$LOAD/indexer_new.sql relative_location
@$LOAD/constraints.sql relative_location
@$LOAD/constraints/relative_location.disable.sql
@$LOAD/indexes/relative_location.drop.sql
INSERT
  INTO relative_location (ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID) SELECT 
                              DISTINCT ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID
                          FROM (SELECT ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID
   FROM marker_relative_location UNION SELECT ID, ORIENTATION, SNP_ID, DISTANCE,
                                                                          BIG_ID
                                                   FROM gene_relative_location);
COMMIT;
CREATE INDEX REL_LOC_BIGID ON relative_location(BIG_ID) TABLESPace cabio_fut;
CREATE INDEX REL_LOC_BIGID_LWR ON relative_location(LOWER(BIG_ID)) TABLESPace 
cabio_fut;
@$LOAD/indexes/relative_location.cols.sql
@$LOAD/indexes/relative_location.lower.sql
@$LOAD/constraints/relative_location.enable.sql
exit;
