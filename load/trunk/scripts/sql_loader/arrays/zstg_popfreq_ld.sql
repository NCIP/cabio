@$LOAD/indexer_new.sql zstg_population_frequency
@$LOAD/constraints.sql zstg_population_frequency
@$LOAD/triggers.sql zstg_population_frequency

@$LOAD/indexes/zstg_population_frequency.drop.sql
@$LOAD/constraints/zstg_population_frequency.disable.sql

EXECUTE zstg_population_frequency_LD;

@$LOAD/indexes/zstg_population_frequency.cols.sql
@$LOAD/indexes/zstg_population_frequency.lower.sql
@$LOAD/constraints/zstg_population_frequency.enable.sql
exit;
~
