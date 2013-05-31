/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/clone_tv.lower.sql;
@$LOAD/indexes/clone_taxon.lower.sql;
@$LOAD/indexes/clone_relative_location.lower.sql;

@$LOAD/indexes/clone_tv.cols.sql;
@$LOAD/indexes/zstg_clone.cols.sql;
@$LOAD/indexes/clone_taxon.cols.sql;
@$LOAD/indexes/clone_relative_location.cols.sql;

@$LOAD/constraints/clone_tv.enable.sql;
@$LOAD/constraints/zstg_clone.enable.sql;
@$LOAD/constraints/clone_taxon.enable.sql;
@$LOAD/constraints/clone_relative_location.enable.sql;

@$LOAD/triggers/clone_tv.enable.sql;
@$LOAD/triggers/zstg_clone.enable.sql;
@$LOAD/triggers/clone_taxon.enable.sql;
@$LOAD/triggers/clone_relative_location.enable.sql;


--ANALYZE TABLE clone_tv COMPUTE STATISTICS;
--ANALYZE TABLE clone_taxon COMPUTE STATISTICS;
--ANALYZE TABLE zstg_clone COMPUTE STATISTICS;

EXIT;
