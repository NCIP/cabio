/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE zstg_human_mrna REUSE STORAGE;
TRUNCATE TABLE zstg_human_est REUSE STORAGE;
TRUNCATE TABLE zstg_mouse_mrna REUSE STORAGE;
TRUNCATE TABLE zstg_mouse_est REUSE STORAGE;

@$LOAD/indexer_new.sql zstg_human_mrna;
@$LOAD/indexer_new.sql zstg_human_est;
@$LOAD/indexer_new.sql zstg_mouse_mrna;
@$LOAD/indexer_new.sql zstg_mouse_est;

@$LOAD/constraints.sql zstg_human_mrna;
@$LOAD/constraints.sql zstg_human_est;
@$LOAD/constraints.sql zstg_mouse_mrna;
@$LOAD/constraints.sql zstg_mouse_est;

@$LOAD/triggers.sql zstg_human_mrna;
@$LOAD/triggers.sql zstg_human_est;
@$LOAD/triggers.sql zstg_mouse_mrna;
@$LOAD/triggers.sql zstg_mouse_est;

@$LOAD/indexes/zstg_human_mrna.drop.sql;
@$LOAD/indexes/zstg_human_est.drop.sql;
@$LOAD/indexes/zstg_mouse_mrna.drop.sql;
@$LOAD/indexes/zstg_mouse_est.drop.sql;

@$LOAD/constraints/zstg_human_mrna.disable.sql;
@$LOAD/constraints/zstg_human_est.disable.sql;
@$LOAD/constraints/zstg_mouse_mrna.disable.sql;
@$LOAD/constraints/zstg_mouse_est.disable.sql;

@$LOAD/triggers/zstg_human_mrna.disable.sql;
@$LOAD/triggers/zstg_human_est.disable.sql;
@$LOAD/triggers/zstg_mouse_mrna.disable.sql;
@$LOAD/triggers/zstg_mouse_est.disable.sql;
EXIT;
