SET SERVEROUTPUT ON;
--WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR EXIT 9;
VAR SPOOLFILENAME VARCHAR2(30);
COLUMN SPOOLFILENAME NEW_VALUE SPOOLFILENAME;
select 'PLSQL_Load.'||to_char(sysdate,'mm-dd-yy')||'.log' as SPOOLFILENAME from dual;
SPOOL &SPOOLFILENAME;
COMMIT;
@$LOAD/indexer_new.sql zstg_biogenes
@$LOAD/indexer_new.sql gene_pathway
@$LOAD/indexer_new.sql biogenes
@$LOAD/indexer_new.sql bio_pathways 
@$LOAD/indexer_new.sql bio_pathways_tv 
@$LOAD/indexer_new.sql zstg_biopathway_descr

@$LOAD/constraints.sql zstg_biogenes
@$LOAD/constraints.sql gene_pathway
@$LOAD/constraints.sql biogenes
@$LOAD/constraints.sql bio_pathways
@$LOAD/constraints.sql zstg_biopathway_descr

@$LOAD/triggers.sql zstg_biogenes
@$LOAD/triggers.sql gene_pathway
@$LOAD/triggers.sql biogenes

@$LOAD/constraints/zstg_biogenes.disable.sql
@$LOAD/constraints/gene_pathway.disable.sql
@$LOAD/constraints/biogenes.disable.sql
@$LOAD/constraints/bio_pathways.disable.sql
@$LOAD/constraints/zstg_biopathway_descr.disable.sql

@$LOAD/triggers/zstg_biogenes.disable.sql
@$LOAD/triggers/gene_pathway.disable.sql
@$LOAD/triggers/biogenes.disable.sql

@$LOAD/indexes/zstg_biogenes.drop.sql
@$LOAD/indexes/gene_pathway.drop.sql
@$LOAD/indexes/biogenes.drop.sql
@$LOAD/indexes/bio_pathways.drop.sql
@$LOAD/indexes/bio_pathways_tv.drop.sql
@$LOAD/indexes/zstg_biopathway_descr.drop.sql

TRUNCATE TABLE ZSTG_BIOGENES REUSE STORAGE;
TRUNCATE TABLE GENE_PATHWAY REUSE STORAGE;
TRUNCATE TABLE BIOGENES REUSE STORAGE;
TRUNCATE TABLE ZSTG_BIOPATHWAY_DESCR REUSE STORAGE;

VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

SELECT MAX(pathway_ID) + 1 AS V_MAXROW FROM bio_pathways;

DROP SEQUENCE bio_pathway_ID_SEQ;
CREATE SEQUENCE bio_pathway_ID_SEQ START WITH &V_MAXROW INCREMENT BY 1;

CREATE OR REPLACE TRIGGER bio_pathway_id_trigger
BEFORE INSERT
ON bio_pathways
FOR EACH ROW
BEGIN
  SELECT bio_pathway_id_seq.NEXTVAL
  INTO :NEW.pathway_id
  FROM DUAL;
END;
/

UPDATE bio_pathways a SET a.pathway_display = (select distinct x.pathway_display from cgap.biopaths@web.nci.nih.gov x WHERE a.pathway_name = x.pathway_name AND a.taxon = decode(x.organism, 'Hs',5,'Mm',6));
commit;

INSERT INTO bio_pathways (pathway_name, pathway_display, taxon) SELECT distinct pathway_name, pathway_display, DECODE (organism, 'Hs', 5, 'Mm', 6) taxon_id FROM cgap.biopaths@web.nci.nih.gov minus select distinct pathway_name, pathway_display, taxon from bio_pathways;
commit;

INSERT INTO zstg_biopathway_descr SELECT * FROM cgap.biopathway_descr@web;
commit;

UPDATE bio_pathways a SET a.pathway_desc = (SELECT pathway_descr FROM zstg_biopathway_descr b WHERE b.path_id = a.pathway_name);
COMMIT;

INSERT INTO zstg_biogenes SELECT DISTINCT pathway_name, DECODE (biog.organism, 'Hs', biog.bc_id, 'Mm', 'Mm.' || biog.bc_id), locus_id, DECODE (biog.organism, 'Hs', 5, 'Mm', 6) taxon_id FROM cgap.biopaths@web.nci.nih.gov biop, cgap.biogenes@web.nci.nih.gov biog WHERE biog.bc_id = biop.bc_id(+) AND biog.organism = biop.organism;
commit;

INSERT INTO biogenes (bc_id, locus_id, organism, gene_id) SELECT DISTINCT bc_id, locus_id, taxon_id, gene_id FROM zstg_biogenes bt, zstg_gene_identifiers gi WHERE bt.locus_id = gi.IDENTIFIER(+) AND gi.data_source(+) = 2;
commit;

--INSERT INTO biogenes (bc_id, locus_id, organism, gene_id) SELECT DISTINCT bc_id, locus_id, g.taxon_id, g.gene_id FROM zstg_biogenes bt, zstg_gene2unigene gi, gene_tv g WHERE bt.locus_id = gi.geneid AND decode(substr(gi.UNIGENE_CLUSTER,0,2),'Hs',5,'Mm',6) = g.taxon_id 	and substr(gi.unigene_cluster,instr(gi.unigene_cluster,'.')+1) = g.CLUSTER_ID;
--commit;

INSERT INTO gene_pathway (pathway_id, bc_id) SELECT DISTINCT pathway_id, bc_id FROM bio_pathways bp, zstg_biogenes bg WHERE bp.pathway_name = bg.pathway_name AND bp.taxon = bg.taxon_id AND bg.pathway_name IS NOT NULL;
commit;

@$LOAD/indexes/zstg_biogenes.cols.sql
@$LOAD/indexes/gene_pathway.cols.sql
@$LOAD/indexes/bio_pathways.cols.sql
@$LOAD/indexes/biogenes.cols.sql
@$LOAD/indexes/zstg_biopathway_descr.cols.sql
@$LOAD/indexes/bio_pathways_tv.cols.sql

@$LOAD/indexes/zstg_biogenes.lower.sql
@$LOAD/indexes/gene_pathway.lower.sql
@$LOAD/indexes/bio_pathways.lower.sql
@$LOAD/indexes/biogenes.lower.sql
@$LOAD/indexes/zstg_biopathway_descr.lower.sql
@$LOAD/indexes/bio_pathways_tv.lower.sql

@$LOAD/constraints/zstg_biogenes.enable.sql
@$LOAD/constraints/gene_pathway.enable.sql
@$LOAD/constraints/bio_pathways.enable.sql
@$LOAD/constraints/biogenes.enable.sql
@$LOAD/constraints/zstg_biopathway_descr.enable.sql

-- Moved to loadGO
--execute load_goevsmod.getgo_rela;

-- Code moved to this file
--execute load_goevsmod.load_pathways;

execute load_goevsmod.getevs;

--execute load_goevsmod.getmod;

EXIT;
spool off
