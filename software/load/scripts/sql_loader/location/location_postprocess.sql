/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/location_tv.lower.sql
@$LOAD/indexes/location_tv.cols.sql
@$LOAD/indexes/location_ch.cols.sql
@$LOAD/indexes/location_ch.lower.sql
@$LOAD/indexes/physical_location.cols.sql
@$LOAD/indexes/physical_location.lower.sql

@$LOAD/constraints/location_tv.enable.sql
@$LOAD/constraints/physical_location.enable.sql
@$LOAD/constraints/location_ch.enable.sql

CREATE INDEX PHYLOC_CHRSTOP ON physical_location(CHROMOSOMAL_END_POSITION) 
TABLESPace cabio_fut;
CREATE INDEX PHYSICALTION_CHROMOSOMA ON physical_location(
              CHROMOSOMAL_END_POSITION) PARALLEL NOLOGGING TABLESPace cabio_fut;
CREATE INDEX LOCHCHENDPOS ON location_ch (CHROMOSOMAL_END_POSITION) tablespace cabio_fut;
CREATE INDEX LOCCHBIGID ON location_ch(BIG_ID) tablespace cabio_fut;
ANALYZE TABLE physical_location COMPUTE STATISTICS;
ANALYZE TABLE location_tv COMPUTE STATISTICS;
ANALYZE TABLE location_ch ESTIMATE STATISTICS;
EXIT;
