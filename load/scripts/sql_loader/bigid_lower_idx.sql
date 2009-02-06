rem -----------------------------------------------------------------------
rem Filename:   idxrecr8.sql
rem Purpose:    Script to spool a listing of all drop and create statements 
rem             required to rebuild indexes.
rem Notes:      Will build all non-sys/system indexes
rem Date:       10-Oct-1998
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

VAR tabName VARCHAR2(50);
COLUMN tabName NEW_VALUE tabName;

spool $LOAD/indexes/drop.sql
SELECT 'drop index ' || B.INDEX_NAME || ';' FROM USER_IND_COLUMNS B WHERE  B.COLUMN_NAME = 'BIG_ID';

SELECT 'EXIT;'
  FROM DUAL;
spool off;


spool $LOAD/indexes/bigid_lower.sql 
SELECT 'create index ' || SUBSTR(A.TABLE_NAME, 1, 7) || SUBSTR(A.TABLE_NAME, -3) 
      || '_' || SUBSTR(A.COLUMN_NAME, 1, 6) || '_lwr on ' || A.TABLE_NAME || 
       '(lower(' 
       || A.COLUMN_NAME || ')) PARALLEL NOLOGGING tablespace ' || NVL(
B.TABLESPace_NAME,
  'cabio_fut') || ';'
  FROM USER_TAB_COLUMNS A, USER_TABLES B
 WHERE LOWER(A.TABLE_NAME) = LOWER(B.TABLE_NAME) AND A.TABLE_NAME =
     B.TABLE_NAME AND A.DATA_TYPE <> 'CLOB' AND A.DATA_TYPE LIKE 'VARCHAR2' AND 
       A.COLUMN_NAME = 'BIG_ID';

SELECT 'EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/indexes/bigid_cols.sql

SELECT 'create index ' || SUBSTR(A.TABLE_NAME, 1, 7) || SUBSTR(A.TABLE_NAME, -3) 
  || '_' || SUBSTR(A.COLUMN_NAME, 1, 6) || ' on ' || A.TABLE_NAME || '(' ||
       A.COLUMN_NAME || ') tablespace ' || B.TABLESPace_NAME || ';'
  FROM USER_TAB_COLUMNS A, USER_TABLES B
 WHERE LOWER(A.TABLE_NAME) = LOWER(B.TABLE_NAME) AND A.TABLE_NAME =
       B.TABLE_NAME AND A.DATA_TYPE <> 'CLOB' AND A.COLUMN_NAME = 'BIG_ID';

SELECT 'EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/constraints/bigid_constraints.sql

SELECT 'alter table ' || A.TABLE_NAME || ' enable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, USER_CONS_COLUMNS B
 WHERE LOWER(A.TABLE_NAME) = LOWER(B.TABLE_NAME) AND A.CONSTRAINT_NAME =
       B.CONSTRAINT_NAME AND B.COLUMN_NAME = 'BIG_ID';

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
