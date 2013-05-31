/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@lch_indexes.sql

@$LOAD/indexes/location_tv.lower.sql
@$LOAD/indexes/location_tv.cols.sql
@$LOAD/indexes/location_ch.cols.sql
@$LOAD/indexes/location_ch.lower.sql
@$LOAD/indexes/physical_location.cols.sql
@$LOAD/indexes/physical_location.lower.sql

@$LOAD/constraints/location_tv.enable.sql
@$LOAD/constraints/physical_location.enable.sql
@$LOAD/constraints/location_ch.enable.sql
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
CREATE INDEX PHYLOC_CHRSTOP ON physical_location(CHROMOSOMAL_END_POSITION) 
TABLESPace &prod_tablspc;
CREATE INDEX PHYSICALTION_CHROMOSOMA ON physical_location(
              CHROMOSOMAL_END_POSITION) PARALLEL NOLOGGING TABLESPace &prod_tablspc;
CREATE INDEX LOCHCHENDPOS ON location_ch (CHROMOSOMAL_END_POSITION) tablespace &prod_tablspc;
CREATE INDEX LOCCHBIGID ON location_ch(BIG_ID) tablespace &prod_tablspc;
ANALYZE TABLE physical_location COMPUTE STATISTICS;
ANALYZE TABLE location_tv COMPUTE STATISTICS;
ANALYZE TABLE location_ch ESTIMATE STATISTICS;

EXIT;
