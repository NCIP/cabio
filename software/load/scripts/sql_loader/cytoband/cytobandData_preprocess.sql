TRUNCATE TABLE zstg_human_cytoband REUSE STORAGE;
TRUNCATE TABLE zstg_mouse_cytoband REUSE STORAGE;
TRUNCATE TABLE cytoband REUSE STORAGE;
TRUNCATE TABLE zstg_map REUSE STORAGE;
TRUNCATE TABLE physical_location REUSE STORAGE;

@$LOAD/constraints.sql zstg_human_cytoband;
@$LOAD/constraints.sql zstg_mouse_cytoband;
@$LOAD/constraints.sql cytoband;
@$LOAD/constraints.sql zstg_map;

@$LOAD/triggers.sql zstg_human_cytoband;
@$LOAD/triggers.sql zstg_mouse_cytoband;
@$LOAD/triggers.sql cytoband;
@$LOAD/triggers.sql zstg_map;

@$LOAD/indexer_new.sql zstg_human_cytoband;
@$LOAD/indexer_new.sql zstg_mouse_cytoband;
@$LOAD/indexer_new.sql cytoband;
@$LOAD/indexer_new.sql zstg_map;

@$LOAD/constraints/zstg_human_cytoband.disable.sql;
@$LOAD/constraints/zstg_mouse_cytoband.disable.sql;
@$LOAD/constraints/cytoband.disable.sql;
@$LOAD/constraints/zstg_map.disable.sql;

@$LOAD/indexes/zstg_human_cytoband.drop.sql;
@$LOAD/indexes/zstg_mouse_cytoband.drop.sql;
@$LOAD/indexes/cytoband.drop.sql;
@$LOAD/indexes/zstg_map.drop.sql;

@$LOAD/triggers/zstg_human_cytoband.disable.sql;
@$LOAD/triggers/zstg_mouse_cytoband.disable.sql;
@$LOAD/triggers/cytoband.disable.sql;
@$LOAD/triggers/zstg_map.disable.sql;
COMMIT;

EXIT;
