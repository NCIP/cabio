TRUNCATE TABLE provenance REUSE STORAGE;
TRUNCATE TABLE url_source_reference REUSE STORAGE;
TRUNCATE TABLE source_reference REUSE STORAGE;


--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql provenance;
@$LOAD/indexer_new.sql url_source_reference;
@$LOAD/indexer_new.sql source_reference;

-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql provenance;
@$LOAD/constraints.sql url_source_reference;
@$LOAD/constraints.sql source_reference;

-- Generate disable and enable triggers for these tables
@$LOAD/triggers.sql provenance;
@$LOAD/triggers.sql url_source_reference;
@$LOAD/triggers.sql source_reference;


-- Disable constraints if any 
@$LOAD/constraints/provenance.disable.sql;
@$LOAD/constraints/url_source_reference.disable.sql;
@$LOAD/constraints/source_reference.disable.sql;

-- Disable triggers if any
@$LOAD/triggers/provenance.disable.sql;
@$LOAD/triggers/url_source_reference.disable.sql;
@$LOAD/triggers/source_reference.disable.sql;


--Drop indexes for relevant tables 
@$LOAD/indexes/provenance.drop.sql;
@$LOAD/indexes/source_reference.drop.sql;
@$LOAD/indexes/url_source_reference.drop.sql;

EXIT;

