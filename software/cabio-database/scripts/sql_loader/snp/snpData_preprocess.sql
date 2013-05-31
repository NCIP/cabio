/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE snp_tv REUSE STORAGE;

--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql snp_tv;

-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql snp_tv;

-- Generate disable and enable triggers for these tables
@$LOAD/triggers.sql snp_tv;

-- Disable constraints if any 
@$LOAD/constraints/snp_tv.disable.sql;

-- Disable triggers if any
@$LOAD/triggers/snp_tv.disable.sql;

--Drop indexes for relevant tables 

@$LOAD/indexes/snp_tv.drop.sql;

EXIT;

