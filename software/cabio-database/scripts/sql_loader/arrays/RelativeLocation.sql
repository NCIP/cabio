TRUNCATE TABLE relative_location REUSE STORAGE;
@$LOAD/indexer_new.sql relative_location
@$LOAD/constraints.sql relative_location
@$LOAD/constraints/relative_location.disable.sql
@$LOAD/indexes/relative_location.drop.sql
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
INSERT
  INTO relative_location (ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID) SELECT 
                              DISTINCT ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID
                          FROM (SELECT ID, ORIENTATION, SNP_ID, DISTANCE, BIG_ID
   FROM marker_relative_location UNION SELECT ID, ORIENTATION, SNP_ID, DISTANCE,
                                                                          BIG_ID
                                                   FROM gene_relative_location);
COMMIT;
CREATE INDEX REL_LOC_BIGID ON relative_location(BIG_ID) TABLESPace &prod_tablspc;
CREATE INDEX REL_LOC_BIGID_LWR ON relative_location(LOWER(BIG_ID)) TABLESPace 
&prod_tablspc;
@$LOAD/indexes/relative_location.cols.sql
@$LOAD/indexes/relative_location.lower.sql
@$LOAD/constraints/relative_location.enable.sql
exit;
