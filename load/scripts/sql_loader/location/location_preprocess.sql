/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE physical_location REUSE STORAGE;
TRUNCATE TABLE location_tv REUSE STORAGE;
TRUNCATE TABLE location_ch REUSE STORAGE;

--perl generate_nas_cyto_phyloc.pl 1> tmp.out & 
--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql physical_location;
@$LOAD/indexer_new.sql location_tv;
@$LOAD/indexer_new.sql location_ch;


-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql physical_location;
@$LOAD/constraints.sql location_tv;
@$LOAD/constraints.sql location_ch;


-- Generate disable and enable triggers for these tables
@$LOAD/triggers.sql physical_location;
@$LOAD/triggers.sql location_tv;
@$LOAD/triggers.sql location_ch;


-- Disable constraints if any 
@$LOAD/constraints/physical_location.disable.sql
@$LOAD/constraints/location_tv.disable.sql
@$LOAD/constraints/location_ch.disable.sql

-- Disable triggers if any
@$LOAD/triggers/physical_location.disable.sql
@$LOAD/triggers/location_tv.disable.sql
@$LOAD/triggers/location_ch.disable.sql


--Drop indexes for relevant tables 
@$LOAD/indexes/physical_location.drop.sql
@$LOAD/indexes/location_tv.drop.sql
@$LOAD/indexes/location_ch.drop.sql

EXIT;

