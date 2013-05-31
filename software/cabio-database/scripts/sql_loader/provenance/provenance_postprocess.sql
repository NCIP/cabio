/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- Provenance stuff should get enabled after all provenance data is loaded
set termout on;
set feedback on;
set verify on;
set echo on;
@$LOAD/indexes/provenance.lower.sql;
@$LOAD/indexes/provenance.cols.sql;
@$LOAD/indexes/url_source_reference.lower.sql;
@$LOAD/indexes/url_source_reference.cols.sql;
@$LOAD/indexes/source_reference.cols.sql;
@$LOAD/indexes/source_reference.lower.sql;

@$LOAD/constraints/provenance.enable.sql
@$LOAD/constraints/url_source_reference.enable.sql
@$LOAD/constraints/source_reference.enable.sql

@$LOAD/triggers/provenance.enable.sql
@$LOAD/triggers/url_source_reference.enable.sql
@$LOAD/triggers/source_reference.enable.sql


--ANALYZE TABLE provenance COMPUTE STATISTICS;
--ANALYZE TABLE url_source_reference COMPUTE STATISTICS;
--ANALYZE TABLE source_reference COMPUTE STATISTICS;

EXIT;
