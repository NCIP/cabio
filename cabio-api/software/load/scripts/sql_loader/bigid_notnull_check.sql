rem -----------------------------------------------------------------------
rem Filename:   bigid_unique_constraints.sql
rem Purpose:    Script to spool a listing of all referential integrity statements 
rem Notes:      Will generate scripts to enable and disable all referential integrity constraints
rem Author:     Anonymous
rem -----------------------------------------------------------------------

set linesize 800;
set pagesize 10000;
set long 50;
set trimspool on;
set termout off;
set echo off;
set feedback off;
set heading off;
set verify off;

col dummy       noprint format a10 wrap word;
col dummy2      noprint format a1 wrap word;
col index_name  noprint format a1 wrap word;
col command     format a10 wrap word;

spool $LOAD/constraints/bigid.notnullcheck.sql

SELECT 'set termout on;' from dual;
SELECT 'set echo on;' from dual;
SELECT 'set feedback on;' from dual;
SELECT 'set heading on;' from dual;
SELECT 'set verify on;' from dual;

SELECT 'select count(*) from ' || A.TABLE_NAME || ' where BIG_ID is NULL;' FROM USER_tables A, USER_tab_COLUMNS B WHERE A.TABLE_NAME = B.table_name AND  B.COLUMN_NAME = 'BIG_ID' and A.TABLE_NAME not like '%ZSTG%';

SELECT 'EXIT;'
  FROM DUAL;
spool off;

set heading on;
set pagesize 100;
set termout on;
set termout on;
set echo on;
set feedback on;
set heading on;
set verify on;

exit;
