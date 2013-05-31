/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexer_new.sql gene_histopathology
@$LOAD/indexer_new.sql histopathology_tst
@$LOAD/indexer_new.sql zstg_gene_kw
@$LOAD/constraints.sql gene_histopathology
@$LOAD/triggers.sql gene_histopathology
@$LOAD/constraints.sql zstg_gene_kw
@$LOAD/triggers.sql zstg_gene_kw

@$LOAD/constraints/gene_histopathology.disable.sql
@$LOAD/indexes/zstg_gene_kw.drop.sql
@$LOAD/triggers/gene_histopathology.disable.sql
@$LOAD/indexes/gene_histopathology.drop.sql
@$LOAD/indexes/histopathology_tst.drop.sql
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
column columnload new_value load_tablspc;
select globals.get_load_tablespace as columnload from dual;
DROP TABLE zstg_gene_kw;
CREATE TABLE zstg_gene_kw tablespace &load_tablspc AS 
SELECT DISTINCT A.GENE_ID, B.CLUSTER_NUMBER,
                               B.library_ID, B.KEYWORD from 
(SELECT DISTINCT CLUSTER_NUMBER, KEYWORD, L.library_ID
       FROM CGAP.HS_EST@WEB.NCI.NIH.GOV GL, CGAP.ALL_LIBRARIES@WEB.NCI.NIH.GOV L
WHERE GL.library_ID = L.unigene_id AND ORG = 'Hs'
union
SELECT DISTINCT
                                           CLUSTER_NUMBER, KEYWORD, L.library_ID
       FROM CGAP.mm_EST@WEB.NCI.NIH.GOV GL, CGAP.ALL_LIBRARIES@WEB.NCI.NIH.GOV L
WHERE GL.library_ID = L.unigene_id AND ORG = 'Mm') B, gene_tv A
                         WHERE B.CLUSTER_NUMBER = A.CLUSTER_ID;
@$LOAD/indexer_new.sql zstg_gene_kw
@$LOAD/indexes/zstg_gene_kw.cols.sql
@$LOAD/constraints/zstg_gene_kw.enable.sql
@$LOAD/triggers/zstg_gene_kw.enable.sql
TRUNCATE TABLE gene_histopathology REUSE STORAGE;
EXIT;
