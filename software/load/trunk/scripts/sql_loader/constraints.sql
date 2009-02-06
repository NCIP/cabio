rem -----------------------------------------------------------------------
rem Filename:   constraints.sql
rem Purpose:    Script to spool a listing of all disable and enable constraints statements 
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

VAR tabName VARCHAR2(50);
COLUMN tabName NEW_VALUE tabName;
SELECT lower('&1') AS TABNAME
  FROM DUAL;
spool $LOAD/constraints/&tabName..disable.sql 

SELECT 'alter table ' || TABLE_NAME || ' disable constraint ' || 
       CONSTRAINT_NAME || ';'
  FROM USER_constraints
 WHERE UPPER(TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE NOT IN ('R');

SELECT '--EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/constraints/&tabName..enable.sql
SELECT 'alter table ' || TABLE_NAME || ' enable constraint ' ||
       CONSTRAINT_NAME || ';'
  FROM USER_constraints
 WHERE UPPER(TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE NOT IN ('R');

SELECT '--EXIT;'
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

--exit;
