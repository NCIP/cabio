# REBUILD indexes FOR gene_tv
@$LOAD/indexes/gene_tv.cols.sql
@$LOAD/indexes/gene_tv.lower.sql
@$LOAD/constraints/gene_tv.enable.sql 

CREATE INDEX GTVCOMP1 ON gene_tv(HUGO_SYMBOL, 1) tablespace cabio_fut;
CREATE INDEX GTVCOMP2 ON gene_tv(SYMBOL, 1) tablespace cabio_fut;
ANALYZE TABLE gene_tv COMPUTE STATISTICS;

COMMIT;
EXIT;
