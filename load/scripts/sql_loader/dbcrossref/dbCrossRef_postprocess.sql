/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/database_cross_reference.lower.sql
@$LOAD/indexes/database_cross_reference.cols.sql

@$LOAD/constraints/database_cross_reference.enable.sql
@$LOAD/triggers/database_cross_reference.enable.sql

ANALYZE TABLE database_cross_reference COMPUTE STATISTICS;

EXIT;
