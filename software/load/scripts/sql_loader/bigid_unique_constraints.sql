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

spool $LOAD/constraints/disable.bigid.sql

SELECT 'alter table ' || A.TABLE_NAME || ' disable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, USER_CONS_COLUMNS B
 WHERE A.TABLE_NAME = B.table_name AND A.CONSTRAINT_TYPE IN ('U') AND
       A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND B.COLUMN_NAME = 'BIG_ID';

SELECT 'EXIT;'
  FROM DUAL;
spool off;


spool $LOAD/constraints/enable.bigid.sql

SELECT 'alter table ' || A.TABLE_NAME || ' enable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, USER_CONS_COLUMNS B
 WHERE A.TABLE_NAME = B.table_name AND A.CONSTRAINT_TYPE IN ('U') AND
       A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND B.COLUMN_NAME = 'BIG_ID';

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
