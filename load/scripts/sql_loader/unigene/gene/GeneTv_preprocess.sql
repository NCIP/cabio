/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE gene_tv REUSE STORAGE;
@$LOAD/indexer_new.sql gene_tv;
@$LOAD/constraints.sql gene_tv;
@$LOAD/triggers.sql gene_tv;

@$LOAD/constraints/gene_tv.disable.sql;
@$LOAD/triggers/gene_tv.disable.sql;
@$LOAD/indexes/gene_tv.drop.sql;
EXIT;
