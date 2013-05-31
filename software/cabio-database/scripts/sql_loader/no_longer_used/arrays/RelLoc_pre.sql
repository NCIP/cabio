/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- populate superclass tables
TRUNCATE TABLE relative_location_ch REUSE STORAGE;
TRUNCATE TABLE relative_location REUSE STORAGE;
@$LOAD/indexer_new.sql relative_location_ch 
@$LOAD/indexer_new.sql relative_location 
@$LOAD/constraints.sql relative_location_ch 
@$LOAD/constraints.sql relative_location 
@$LOAD/constraints/relative_location_ch.disable.sql 
@$LOAD/constraints/relative_location.disable.sql 
@$LOAD/indexes/relative_location_ch.drop.sql 
@$LOAD/indexes/relative_location.drop.sql 
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
COMMIT;

CREATE INDEX RELATIVE_LOC_BIGID ON relative_location_ch(BIG_ID) TABLESPace 
&prod_tablspc;
CREATE INDEX RELATIVE_LOC_BIGID_LWR ON relative_location_ch(LOWER(BIG_ID)) 
TABLESPace &prod_tablspc;
@$LOAD/indexes/relative_location_ch.lower.sql 
@$LOAD/indexes/relative_location_ch.cols.sql 
@$LOAD/constraints/relative_location_ch.enable.sql 
exit;
