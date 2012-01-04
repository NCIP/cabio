TRUNCATE TABLE marker REUSE STORAGE;
TRUNCATE TABLE marker_alias REUSE STORAGE;
TRUNCATE TABLE marker_marker_alias REUSE STORAGE;
TRUNCATE TABLE gene_marker REUSE STORAGE;
TRUNCATE TABLE zstg_marker_alias REUSE STORAGE;
TRUNCATE TABLE marker_lookup REUSE STORAGE;

@$LOAD/indexer_new.sql marker;
@$LOAD/indexer_new.sql marker_alias;
@$LOAD/indexer_new.sql marker_marker_alias;
@$LOAD/indexer_new.sql gene_marker;
@$LOAD/indexer_new.sql zstg_marker_alias;
@$LOAD/indexer_new.sql marker_lookup;

@$LOAD/constraints.sql marker;
@$LOAD/constraints.sql marker_alias;
@$LOAD/constraints.sql marker_marker_alias;
@$LOAD/constraints.sql gene_marker;
@$LOAD/constraints.sql zstg_marker_alias;
@$LOAD/constraints.sql marker_lookup;

@$LOAD/triggers.sql marker;
@$LOAD/triggers.sql marker_alias;
@$LOAD/triggers.sql marker_marker_alias;
@$LOAD/triggers.sql gene_marker;
@$LOAD/triggers.sql zstg_marker_alias;

@$LOAD/triggers/marker.disable.sql;
@$LOAD/triggers/marker_alias.disable.sql;
@$LOAD/triggers/marker_marker_alias.disable.sql;
@$LOAD/triggers/gene_marker.disable.sql;
@$LOAD/triggers/zstg_marker_alias.disable.sql;

@$LOAD/constraints/marker.disable.sql;
@$LOAD/constraints/marker_alias.disable.sql;
@$LOAD/constraints/marker_marker_alias.disable.sql;
@$LOAD/constraints/gene_marker.disable.sql;
@$LOAD/constraints/zstg_marker_alias.disable.sql;

@$LOAD/indexes/marker.drop.sql;
@$LOAD/indexes/marker_alias.drop.sql;
@$LOAD/indexes/marker_marker_alias.drop.sql;
@$LOAD/indexes/gene_marker.drop.sql;
@$LOAD/indexes/zstg_marker_alias.drop.sql;
@$LOAD/indexes/marker_lookup.drop.sql;
EXIT;
