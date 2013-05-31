/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE clone_tv REUSE STORAGE;
TRUNCATE TABLE zstg_clone REUSE STORAGE;
TRUNCATE TABLE clone_taxon REUSE STORAGE;
TRUNCATE TABLE clone_relative_location REUSE STORAGE;

@$LOAD/indexer_new.sql clone_tv;
@$LOAD/indexer_new.sql zstg_clone;
@$LOAD/indexer_new.sql clone_taxon;
@$LOAD/indexer_new.sql clone_relative_location;


@$LOAD/constraints.sql clone_tv;
@$LOAD/constraints.sql zstg_clone;
@$LOAD/constraints.sql clone_taxon;
@$LOAD/constraints.sql clone_relative_location;

@$LOAD/triggers.sql clone_tv;
@$LOAD/triggers.sql zstg_clone;
@$LOAD/triggers.sql clone_taxon;
@$LOAD/triggers.sql clone_relative_location;


@$LOAD/constraints/clone_tv.disable.sql;
@$LOAD/constraints/zstg_clone.disable.sql;
@$LOAD/constraints/clone_taxon.disable.sql;
@$LOAD/constraints/clone_relative_location.disable.sql;


@$LOAD/triggers/clone_tv.disable.sql;
@$LOAD/triggers/zstg_clone.disable.sql;
@$LOAD/triggers/clone_taxon.disable.sql;
@$LOAD/triggers/clone_relative_location.disable.sql;


@$LOAD/indexes/clone_tv.drop.sql;
@$LOAD/indexes/zstg_clone.drop.sql;
@$LOAD/indexes/clone_taxon.drop.sql;
@$LOAD/indexes/clone_relative_location.drop.sql;
EXIT;
