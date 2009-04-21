--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql taxon;
@$LOAD/indexer_new.sql multiple_alignment;
@$LOAD/indexer_new.sql multiple_alignment_taxon;
@$LOAD/indexer_new.sql location_ch_43;

-- Generate constraint disable and enable scripts
@$LOAD/constraints.sql taxon;
@$LOAD/constraints.sql multiple_alignment;
@$LOAD/constraints.sql multiple_alignment_taxon;
@$LOAD/constraints.sql location_ch_43;

-- Disable constraints if any 
@$LOAD/constraints/taxon.disable.sql;
@$LOAD/constraints/multiple_alignment.disable.sql;
@$LOAD/constraints/multiple_alignment_taxon.disable.sql;
@$LOAD/constraints/location_ch_43.disable.sql;

--Drop indexes for relevant tables 
@$LOAD/indexes/taxon.drop.sql;
@$LOAD/indexes/multiple_alignment.drop.sql;
@$LOAD/indexes/multiple_alignment_taxon.drop.sql;
@$LOAD/indexes/location_ch_43.drop.sql;

EXIT;

