/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

SET SERVEROUTPUT ON;
WHENEVER OSERROR EXIT 9;
VAR SPOOLFILENAME VARCHAR2(30);
COLUMN SPOOLFILENAME NEW_VALUE SPOOLFILENAME;
select 'CGAP_PLSQL_Load.'||to_char(sysdate,'mm-dd-yy')||'.log' as SPOOLFILENAME from dual;
SPOOL &SPOOLFILENAME;
--Generates drop, re-create and rebuild scripts for the below tables
--these scripts can be run at the appropriate times
@$LOAD/indexer_new.sql library
@$LOAD/constraints.sql library 
@$LOAD/triggers.sql library 

@$LOAD/indexer_new.sql tissue_sample 
@$LOAD/constraints.sql tissue_sample  
@$LOAD/triggers.sql tissue_sample

@$LOAD/indexer_new.sql library_histopathology 
@$LOAD/constraints.sql library_histopathology  
@$LOAD/triggers.sql library_histopathology

@$LOAD/indexer_new.sql library_keyword 
@$LOAD/constraints.sql library_keyword  
@$LOAD/triggers.sql library_keyword

@$LOAD/indexes/library.drop.sql;
@$LOAD/constraints/library.disable.sql;
@$LOAD/triggers/library.disable.sql;

@$LOAD/indexes/tissue_sample.drop.sql;
@$LOAD/constraints/tissue_sample.disable.sql;
@$LOAD/triggers/tissue_sample.disable.sql;

@$LOAD/indexes/library_histopathology.drop.sql;
@$LOAD/constraints/library_histopathology.disable.sql;
@$LOAD/triggers/library_histopathology.disable.sql;

@$LOAD/indexes/library_keyword.drop.sql;
@$LOAD/constraints/library_keyword.disable.sql;
@$LOAD/triggers/library_keyword.disable.sql;

truncate table LIBRARY_HISTOPATHOLOGY;
execute load_data.load_libraries;

@$LOAD/indexes/library.cols.sql;
@$LOAD/indexes/library.lower.sql;
@$LOAD/constraints/library.enable.sql;

@$LOAD/indexes/tissue_sample.lower.sql;
@$LOAD/indexes/tissue_sample.cols.sql;
@$LOAD/constraints/tissue_sample.enable.sql;

@$LOAD/indexes/library_histopathology.lower.sql;
@$LOAD/indexes/library_histopathology.cols.sql;
@$LOAD/constraints/library_histopathology.enable.sql;

@$LOAD/indexes/library_keyword.lower.sql;
@$LOAD/indexes/library_keyword.cols.sql;
@$LOAD/constraints/library_keyword.enable.sql;
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
CREATE INDEX tissuecode_parent on tissue_code(parent) tablespace &prod_tablspc;
CREATE INDEX tissuecode_relationship on tissue_code(relationship) &prod_tablspc;
COMMIT;
analyze table tissue_code compute statistics;

CREATE INDEX histcode_parent on histology_code(parent) tablespace &prod_tablspc;
CREATE INDEX histcode_relationship on histology_code(relationship) tablespace &prod_tablspc;
COMMIT;
analyze table histology_code compute statistics;

COMMIT;
EXIT;
