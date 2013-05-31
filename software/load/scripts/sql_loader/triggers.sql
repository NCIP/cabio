/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

rem -----------------------------------------------------------------------
rem Filename:   idxrecr8.SQL
rem Purpose:    Script to spool a listing of all drop and create statements 
rem             required to rebuild indexes.
rem Notes:      Will build all non-sys/system indexes
rem Date:       10-Oct-1998
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
spool $LOAD/triggers/&tabName..disable.sql 

SELECT 'alter trigger ' || TRIGGER_NAME || ' DISABLE;'
  FROM USER_triggers
 WHERE UPPER(TABLE_NAME) = UPPER('&1');

SELECT '--EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/triggers/&tabName..enable.sql

SELECT 'alter trigger ' || TRIGGER_NAME || ' ENABLE;'
  FROM USER_triggers
 WHERE UPPER(TABLE_NAME) = UPPER('&1');

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
