/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/arrays/truncate_staging_tables.sql
@$LOAD/arrays/array_constraints.sql
@$LOAD/arrays/array_indexes.sql
@$LOAD/arrays/array_triggers.sql
@$LOAD/arrays/array_disableConstraints.sql
@$LOAD/arrays/array_dropIndexes.sql
@$LOAD/arrays/array_disableTriggers.sql
EXIT;
