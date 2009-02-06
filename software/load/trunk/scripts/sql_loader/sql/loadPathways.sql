SET SERVEROUTPUT ON;
--WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR EXIT 9;
VAR SPOOLFILENAME VARCHAR2(30);
COLUMN SPOOLFILENAME NEW_VALUE SPOOLFILENAME;
select 'PLSQL_Load.'||to_char(sysdate,'mm-dd-yy')||'.log' as SPOOLFILENAME from dual;
SPOOL &SPOOLFILENAME;
COMMIT;
delete from protein_alias where rowid not in (select MIN(rowid) from protein_alias group by protein_ID, name); 
@$LOAD/indexer_new.sql zstg_biogenes
@$LOAD/indexer_new.sql gene_pathway
@$LOAD/indexer_new.sql biogenes
@$LOAD/indexer_new.sql bio_pathways 
@$LOAD/indexer_new.sql bio_pathways_tv 

@$LOAD/constraints.sql zstg_biogenes
@$LOAD/constraints.sql gene_pathway
@$LOAD/constraints.sql biogenes

@$LOAD/triggers.sql zstg_biogenes
@$LOAD/triggers.sql gene_pathway
@$LOAD/triggers.sql biogenes

@$LOAD/constraints/zstg_biogenes.disable.sql
@$LOAD/constraints/gene_pathway.disable.sql
@$LOAD/constraints/biogenes.disable.sql

@$LOAD/triggers/zstg_biogenes.disable.sql
@$LOAD/triggers/gene_pathway.disable.sql
@$LOAD/triggers/biogenes.disable.sql

@$LOAD/indexes/zstg_biogenes.drop.sql
@$LOAD/indexes/gene_pathway.drop.sql
@$LOAD/indexes/biogenes.drop.sql
@$LOAD/indexes/bio_pathways.drop.sql
@$LOAD/indexes/bio_pathways_tv.drop.sql

execute load_goevsmod.getgo_rela;
execute load_goevsmod.load_pathways;
--execute load_goevsmod.getevs;
execute load_goevsmod.getmod;


CREATE INDEX GO_ANCESTO_INDEX ON go_closure(ANCESTOR, GO_CODE);
CREATE INDEX GO_CHILD_INDEX ON go_closure(GO_CODE, ANCESTOR);
COMMIT;

@$LOAD/indexes/zstg_biogenes.cols.sql
@$LOAD/indexes/gene_pathway.cols.sql
@$LOAD/indexes/biogenes.cols.sql
@$LOAD/indexes/bio_pathways.cols.sql
@$LOAD/indexes/bio_pathways_tv.cols.sql

@$LOAD/indexes/zstg_biogenes.lower.sql
@$LOAD/indexes/gene_pathway.lower.sql
@$LOAD/indexes/biogenes.lower.sql
@$LOAD/indexes/bio_pathways.lower.sql
@$LOAD/indexes/bio_pathways_tv.lower.sql

@$LOAD/constraints/zstg_biogenes.enable.sql
@$LOAD/constraints/gene_pathway.enable.sql
@$LOAD/constraints/biogenes.enable.sql

@$LOAD/triggers/zstg_biogenes.enable.sql
@$LOAD/triggers/gene_pathway.enable.sql
@$LOAD/triggers/biogenes.enable.sql


EXIT;
spool off
