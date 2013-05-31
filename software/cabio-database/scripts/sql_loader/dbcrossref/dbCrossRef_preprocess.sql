/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE database_cross_reference REUSE STORAGE;

--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql database_cross_reference;

-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql database_cross_reference;

-- Generate disable and enable triggers for these tables
@$LOAD/triggers.sql database_cross_reference;

-- Disable constraints if any 
@$LOAD/constraints/database_cross_reference.disable.sql;

-- Disable triggers if any
@$LOAD/triggers/database_cross_reference.disable.sql;

--Drop indexes for relevant tables 

@$LOAD/indexes/database_cross_reference.drop.sql;

EXIT;

