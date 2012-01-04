# REBUILD indexes FOR gene_tv
@$LOAD/indexes/gene_tv.cols.sql
@$LOAD/indexes/gene_tv.lower.sql
@$LOAD/constraints/gene_tv.enable.sql 
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
CREATE INDEX GTVCOMP1 ON gene_tv(HUGO_SYMBOL, 1) tablespace &prod_tablspc;
CREATE INDEX GTVCOMP2 ON gene_tv(SYMBOL, 1) tablespace &prod_tablspc;
UPDATE GENE_TV SET SOURCE = 'Unigene';
ANALYZE TABLE gene_tv COMPUTE STATISTICS;

COMMIT;
EXIT;
