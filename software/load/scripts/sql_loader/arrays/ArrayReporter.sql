/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE array_reporter REUSE STORAGE;
@$LOAD/indexer_new.sql array_reporter
@$LOAD/constraints.sql array_reporter
@$LOAD/constraints/array_reporter.disable.sql
@$LOAD/indexes/array_reporter.drop.sql
INSERT
 INTO array_reporter (ID, NAME, microarray_ID, BIG_ID) SELECT DISTINCT ID, NAME,
                                                           microarray_ID, BIG_ID
                                    FROM (SELECT ID, NAME, microarray_ID, BIG_ID
           FROM expression_reporter UNION SELECT ID, NAME, microarray_ID, BIG_ID
                  FROM snp_reporter UNION SELECT ID, NAME, microarray_ID, BIG_ID
                                                            FROM exon_reporter);
COMMIT;
CREATE INDEX ARRAY_REP_BIGID ON array_reporter(BIG_ID) TABLESPace cabio_fut;
CREATE INDEX ARRAY_REP_BIGID_LWR ON array_reporter(LOWER(BIG_ID)) TABLESPace 
cabio_fut;
@$LOAD/indexes/array_reporter.cols.sql
@$LOAD/indexes/array_reporter.lower.sql
@$LOAD/constraints/array_reporter.enable.sql

exit;
