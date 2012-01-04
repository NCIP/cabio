-- populate superclass tables
TRUNCATE TABLE relative_location_ch REUSE STORAGE;
@$LOAD/indexer_new.sql relative_location_ch 
@$LOAD/constraints.sql relative_location_ch 
@$LOAD/constraints/relative_location_ch.disable.sql 
@$LOAD/indexes/relative_location_ch.drop.sql 
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
INSERT
INTO relative_location_ch (ID, ORIENTATION, TYPE, DISTANCE, SNP_ID, PROBE_SET_ID
,
 BIG_ID, DISCRIMINATOR) SELECT DISTINCT ID, ORIENTATION, TYPE, DISTANCE, SNP_ID,
                 PROBE_SET_ID, BIG_ID, 'MarkerRelativeLocation' AS DISCRIMINATOR
                           FROM marker_relative_location;
COMMIT;
INSERT
  INTO relative_location_ch (ID, ORIENTATION, DISTANCE, gene_ID, SNP_ID,
PROBE_SET_ID, BIG_ID, DISCRIMINATOR) SELECT DISTINCT ID, ORIENTATION, DISTANCE,
                   gene_ID, SNP_ID, PROBE_SET_ID, BIG_ID, 'GeneRelativeLocation'
                                       FROM gene_relative_location;
COMMIT;
CREATE INDEX RELATIVE_LOC_BIGID ON relative_location_ch(BIG_ID) TABLESPace 
&prod_tablspc;
CREATE INDEX RELATIVE_LOC_BIGID_LWR ON relative_location_ch(LOWER(BIG_ID)) 
TABLESPace &prod_tablspc;
@$LOAD/indexes/relative_location_ch.lower.sql 
@$LOAD/indexes/relative_location_ch.cols.sql 
@$LOAD/constraints/relative_location_ch.enable.sql 
exit;
