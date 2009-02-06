TRUNCATE TABLE gene_tv REUSE STORAGE;
@$LOAD/indexer_new.sql gene_tv;
@$LOAD/constraints.sql gene_tv;
@$LOAD/triggers.sql gene_tv;

@$LOAD/constraints/gene_tv.disable.sql;
@$LOAD/triggers/gene_tv.disable.sql;
@$LOAD/indexes/gene_tv.drop.sql;
EXIT;
