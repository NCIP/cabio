/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

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

-- Disable constraints 
@$LOAD/constraints/taxon.disable.sql;
@$LOAD/constraints/multiple_alignment.disable.sql;
@$LOAD/constraints/multiple_alignment_taxon.disable.sql;
@$LOAD/constraints/location_ch_43.disable.sql;

-- Truncate target tables
truncate table TAXON;
truncate table MULTIPLE_ALIGNMENT;
truncate table MULTIPLE_ALIGNMENT_TAXON;
truncate table LOCATION_CH_43;

--Drop indexes for relevant tables 
@$LOAD/indexes/taxon.drop.sql;
@$LOAD/indexes/multiple_alignment.drop.sql;
@$LOAD/indexes/multiple_alignment_taxon.drop.sql;
@$LOAD/indexes/location_ch_43.drop.sql;

EXIT;

