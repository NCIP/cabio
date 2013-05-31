/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

set echo on;
set feedback on;
set heading on;
set verify on;

@$LOAD/indexes/zstg_human_est.cols.sql;
@$LOAD/indexes/zstg_human_mrna.cols.sql;
@$LOAD/indexes/zstg_mouse_est.cols.sql;
@$LOAD/indexes/zstg_mouse_mrna.cols.sql;

@$LOAD/constraints/zstg_human_est.enable.sql;
@$LOAD/constraints/zstg_human_mrna.enable.sql;
@$LOAD/constraints/zstg_mouse_est.enable.sql;
@$LOAD/constraints/zstg_mouse_mrna.enable.sql;

@$LOAD/triggers/zstg_human_est.enable.sql;
@$LOAD/triggers/zstg_human_mrna.enable.sql;
@$LOAD/triggers/zstg_mouse_est.enable.sql;
@$LOAD/triggers/zstg_mouse_mrna.enable.sql;

--ANALYZE TABLE zstg_human_est COMPUTE STATISTICS;
--ANALYZE TABLE zstg_mouse_est COMPUTE STATISTICS;
--ANALYZE TABLE zstg_mouse_mrna COMPUTE STATISTICS;
--ANALYZE TABLE zstg_human_mrna COMPUTE STATISTICS;

EXIT;
