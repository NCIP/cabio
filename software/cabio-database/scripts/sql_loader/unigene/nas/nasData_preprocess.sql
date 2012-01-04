TRUNCATE TABLE nucleic_acid_sequence REUSE STORAGE;
@$LOAD/indexer_new.sql nucleic_acid_sequence;
@$LOAD/constraints.sql nucleic_acid_sequence;
@$LOAD/triggers.sql nucleic_acid_sequence;


@$LOAD/constraints/nucleic_acid_sequence.disable.sql;
@$LOAD/triggers/nucleic_acid_sequence.disable.sql;
@$LOAD/indexes/nucleic_acid_sequence.drop.sql;

EXIT;
