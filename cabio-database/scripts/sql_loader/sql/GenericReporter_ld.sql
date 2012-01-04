
-- truncate tables

truncate table generic_array_generic_reporter;
truncate table generic_reporter;
truncate table generic_array;
@$LOAD/indexer_new.sql generic_reporter
@$LOAD/indexer_new.sql generic_array
@$LOAD/indexer_new.sql generic_array_generic_reporter

@$LOAD/constraints.sql generic_reporter
@$LOAD/constraints.sql generic_array
@$LOAD/constraints.sql generic_array_generic_reporter

@$LOAD/triggers.sql generic_reporter
@$LOAD/triggers.sql generic_array
@$LOAD/triggers.sql generic_array_generic_reporter

@$LOAD/constraints/generic_reporter.disable.sql
@$LOAD/constraints/generic_array.disable.sql
@$LOAD/constraints/generic_array_generic_reporter.disable.sql

@$LOAD/indexes/generic_reporter.drop.sql
@$LOAD/indexes/generic_array.drop.sql
@$LOAD/indexes/generic_array_generic_reporter.drop.sql

-- affy hgu133 array
drop sequence genericrep_id;
create sequence genericrep_id;
alter trigger set_genericrep_id enable;
insert into generic_reporter(name, type, gene_id)
    select distinct a.probe_set_id, 'AFFYMETRIX', c.gene_id
    from ar_rna_probesets_affy a, ar_unigene_id b, gene_tv c	 
    where a.probe_set_id = b.probe_set_id(+)
    and b.unigene_id = 'Hs.'||c.cluster_id(+);

commit;

alter trigger set_genericrep_id disable;
insert into generic_array (id, array_name, platform, type) 
    values (1, 'Human Genome U133 Plus 2.0 Array', 'Affymetrix', 'oligo');

insert into generic_array_generic_reporter (generic_array_id, generic_reporter_id) 
    select 1, reporter.id 
    from generic_reporter reporter;

commit;


@$LOAD/indexes/generic_reporter.cols.sql
@$LOAD/indexes/generic_array.cols.sql
@$LOAD/indexes/generic_array_generic_reporter.cols.sql

@$LOAD/indexes/generic_reporter.lower.sql
@$LOAD/indexes/generic_array.lower.sql
@$LOAD/indexes/generic_array_generic_reporter.lower.sql

@$LOAD/constraints/generic_reporter.enable.sql
@$LOAD/constraints/generic_array.enable.sql
@$LOAD/constraints/generic_array_generic_reporter.enable.sql

@$LOAD/triggers/generic_reporter.enable.sql
@$LOAD/triggers/generic_array.enable.sql
@$LOAD/triggers/generic_array_generic_reporter.enable.sql

EXIT;
