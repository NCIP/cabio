
TRUNCATE TABLE population_frequency REUSE STORAGE;
@$LOAD/indexer_new.sql population_frequency
@$LOAD/constraints.sql population_frequency
@$LOAD/triggers.sql population_frequency

@$LOAD/constraints/population_frequency.disable.sql
@$LOAD/triggers/population_frequency.disable.sql
@$LOAD/indexes/population_frequency.drop.sql
exit;
