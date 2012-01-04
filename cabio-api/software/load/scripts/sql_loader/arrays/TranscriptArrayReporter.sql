TRUNCATE TABLE transcript_array_reporter;
@$LOAD/indexer_new.sql transcript_array_reporter
@$LOAD/constraints.sql transcript_array_reporter
@$LOAD/constraints/transcript_array_reporter.disable.sql
@$LOAD/indexes/transcript_array_reporter.drop.sql
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
INSERT
INTO transcript_array_reporter (ID, NAME, microarray_ID, BIG_ID) SELECT ID, NAME
                                                                          ,
                                                           microarray_ID, BIG_ID
                                    FROM (SELECT ID, NAME, microarray_ID, BIG_ID
           FROM expression_reporter UNION SELECT ID, NAME, microarray_ID, BIG_ID
                                                            FROM exon_reporter);

COMMIT;
CREATE INDEX TRANSARREP_BIGID_IDX ON transcript_array_reporter(BIG_ID) TABLESPace &prod_tablspc;
@$LOAD/indexes/transcript_array_reporter.cols.sql
@$LOAD/indexes/transcript_array_reporter.lower.sql
@$LOAD/constraints/transcript_array_reporter.enable.sql
exit;
