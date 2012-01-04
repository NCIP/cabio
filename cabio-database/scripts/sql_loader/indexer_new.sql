rem -----------------------------------------------------------------------
rem Filename:   indexer_new.sql
rem Purpose:    Script to generate drop and create index scripts 
rem Notes:      Will build all non-sys/system indexes
rem Author:     Anonymous
rem -----------------------------------------------------------------------

set linesize 300;
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
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
VAR tabName VARCHAR2(50);
COLUMN tabName NEW_VALUE tabName;
SELECT lower('&1') AS TABNAME
  FROM DUAL;

spool $LOAD/indexes/&tabName..drop.sql
SELECT 'drop index ' || A.INDEX_NAME || ';'
  FROM USER_indexes A
 WHERE UPPER(A.TABLE_NAME) = UPPER('&1');
SELECT '--EXIT;'
  FROM DUAL;
spool off;


spool $LOAD/indexes/&tabName..lower.sql 
SELECT 'create index ' || SUBSTR(A.TABLE_NAME, 1, 8) || SUBSTR(A.TABLE_NAME, -4) 
       || '_' || SUBSTR(A.COLUMN_NAME, 1, 10) || '_lwr on ' || A.TABLE_NAME || 
       '(lower(' || A.COLUMN_NAME || ')) PARALLEL NOLOGGING tablespace ' || NVL(
B.TABLESPace_NAME, '&prod_tablspc') || ';'
  FROM USER_TAB_COLUMNS A, USER_TABLES B
 WHERE UPPER(A.TABLE_NAME) = UPPER('&1') AND A.TABLE_NAME = B.TABLE_NAME AND 
       A.DATA_TYPE LIKE '%VARCHAR%' AND A.COLUMN_NAME <> 'BIG_ID';

SELECT '--EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/indexes/&tabName..cols.sql

SELECT 'create index ' || SUBSTR(A.TABLE_NAME, 1, 8) || SUBSTR(A.TABLE_NAME, -4) 
      || '_' || SUBSTR(A.COLUMN_NAME, 1, 10) || ' on ' || A.TABLE_NAME || '(' || 
   A.COLUMN_NAME || ') PARALLEL NOLOGGING tablespace ' || NVL(B.TABLESPace_NAME, 
'&prod_tablspc') || ';'
  FROM USER_TAB_COLUMNS A, USER_TABLES B
 WHERE UPPER(A.TABLE_NAME) = UPPER('&1') AND A.TABLE_NAME = B.TABLE_NAME AND 
       A.DATA_TYPE <> 'CLOB' AND A.DATA_TYPE <> 'LONG'  AND 
       A.COLUMN_NAME <> 'BIG_ID';

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
