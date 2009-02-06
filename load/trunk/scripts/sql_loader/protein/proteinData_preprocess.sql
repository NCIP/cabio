TRUNCATE TABLE new_protein REUSE STORAGE;
TRUNCATE TABLE protein_alias REUSE STORAGE;
TRUNCATE TABLE protein_protein_alias REUSE STORAGE;
TRUNCATE TABLE zstg_protein_embl REUSE STORAGE;
TRUNCATE TABLE protein_keywords REUSE STORAGE;
TRUNCATE TABLE protein_secondary_accession REUSE STORAGE;
TRUNCATE TABLE protein_sequence REUSE STORAGE;
TRUNCATE TABLE protein_taxon REUSE STORAGE;

-- Generates drop, re-create and rebuild scripts for the below tables
-- these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql new_protein;
@$LOAD/indexer_new.sql protein_alias;
@$LOAD/indexer_new.sql protein_protein_alias;
@$LOAD/indexer_new.sql zstg_protein_embl;
@$LOAD/indexer_new.sql protein_keywords;
@$LOAD/indexer_new.sql protein_secondary_accession;
@$LOAD/indexer_new.sql protein_sequence;
@$LOAD/indexer_new.sql protein_taxon;


-- Generate disable constraints and enable constraints scripts 
@$LOAD/constraints.sql new_protein;
@$LOAD/constraints.sql protein_alias;
@$LOAD/constraints.sql PROTEIN_protein_alias;
@$LOAD/constraints.sql zstg_protein_embl;
@$LOAD/constraints.sql protein_keywords;
@$LOAD/constraints.sql protein_secondary_accession;
@$LOAD/constraints.sql protein_sequence;
@$LOAD/constraints.sql protein_taxon;


@$LOAD/triggers.sql new_protein;
@$LOAD/triggers.sql protein_alias;
@$LOAD/triggers.sql protein_protein_alias;
@$LOAD/triggers.sql zstg_protein_embl;
@$LOAD/triggers.sql protein_keywords;
@$LOAD/triggers.sql protein_secondary_accession;
@$LOAD/triggers.sql protein_sequence;
@$LOAD/triggers.sql protein_taxon;


-- Generate disable and enable triggers on these tables
@$LOAD/triggers/new_protein.disable.sql;
@$LOAD/triggers/protein_alias.disable.sql;
@$LOAD/triggers/protein_protein_alias.disable.sql;
@$LOAD/triggers/zstg_protein_embl.disable.sql;
@$LOAD/triggers/protein_keywords.disable.sql;
@$LOAD/triggers/protein_secondary_accession.disable.sql;
@$LOAD/triggers/protein_sequence.disable.sql;
@$LOAD/triggers/protein_taxon.disable.sql;

-- Disable constraints
@$LOAD/constraints/new_protein.disable.sql;
@$LOAD/constraints/protein_alias.disable.sql;
@$LOAD/constraints/protein_protein_alias.disable.sql;
@$LOAD/constraints/zstg_protein_embl.disable.sql;
@$LOAD/constraints/protein_keywords.disable.sql;
@$LOAD/constraints/protein_secondary_accession.disable.sql;
@$LOAD/constraints/protein_sequence.disable.sql;
@$LOAD/constraints/protein_taxon.disable.sql;


-- Drop indexes
@$LOAD/indexes/new_protein.drop.sql;
@$LOAD/indexes/protein_alias.drop.sql;
@$LOAD/indexes/protein_protein_alias.drop.sql;
@$LOAD/indexes/zstg_protein_embl.drop.sql;
@$LOAD/indexes/protein_keywords.drop.sql;
@$LOAD/indexes/protein_secondary_accession.drop.sql;
@$LOAD/indexes/protein_sequence.drop.sql;
@$LOAD/indexes/protein_taxon.drop.sql;
EXIT;
